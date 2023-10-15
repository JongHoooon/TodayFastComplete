//
//  TimerUseCaseImp.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/9/23.
//

import Foundation

import UIKit

import RxSwift

typealias TimerUseCase = RoutineSettingFetchable & RoutineSettingStoragable

final class TimerUseCaseImp: TimerUseCase {
    private let routineSettingRepository: TimerRoutineSettingRepository
    private let userNotificationManager: UserNotificationManager
    private let disposeBag: DisposeBag
    
    init(
        routineSettingRepository: TimerRoutineSettingRepository,
        userNotificationManager: UserNotificationManager
    ) {
        self.routineSettingRepository = routineSettingRepository
        self.userNotificationManager = userNotificationManager
        self.disposeBag = DisposeBag()
    }
    
    func fetchTimerRoutine() -> Single<TimerRoutineSetting?> {
        return routineSettingRepository.fetchRoutine()
    }
    
    func saveRoutineSetting(with routineSetting: TimerRoutineSetting) -> Single<TimerRoutineSetting> {
        removePreviousFastNotifications()
            .flatMap { [unowned self] _ in self.removePreviousFastNotifications() }
            .flatMap { [unowned self] _ in
                return Single.zip(
                    self.scheduleNotifications(routineSetting: routineSetting),
                    self.routineSettingRepository.update(routineSetting: routineSetting)
                )
            }
            .map { $0.1 }
    }
    
    func deleteRoutineSetting() -> Single<Void> {
        return Single.zip(
            routineSettingRepository.deleteRoutine(),
            userNotificationManager.removeNotifications(type: .fastEnd),
            userNotificationManager.removeNotifications(type: .fastStart)
        )
        .map { _ in }
    }
}

private extension TimerUseCaseImp {
    func scheduleNotifications(routineSetting: TimerRoutineSetting) -> Single<Void> {
        return userNotificationManager.pendingNotificationCount()
            .map { Constants.DefaultValue.localNotificationMaxCount - $0 - 4 }
            .map { [weak self] maxCount -> [CalendarNotification] in
                guard let self else { return [] }
                return self.userNotificationManager.fastNotifications(
                    maxCount: maxCount,
                    fastDays: routineSetting.days,
                    routineSetting: routineSetting
                )
            }
            .flatMap { [unowned self] in
                return self.userNotificationManager.schedule(calendarNotifications: $0)
            }
            .map { _ in }
            .subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
    }
    
    func removePreviousFastNotifications() -> Single<Void> {
        return Single.zip(
            userNotificationManager.removeNotifications(type: .fastStart),
            userNotificationManager.removeNotifications(type: .fastEnd)
        )
        .map { _ in }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
    }
}

/*
 알람 등록, 전부 삭제해야됨
 week days 기반으로 알림 등록
 
 시작알림 끝 알림
 
 */
