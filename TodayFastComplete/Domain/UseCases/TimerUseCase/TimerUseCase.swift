//
//  TimerUseCaseImp.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/9/23.
//

import Foundation

import UIKit

import RxSwift

typealias TimerUseCase = RoutineSettingFetchable & RoutineSettingStoragable & FastInterruptable

final class TimerUseCaseImp: TimerUseCase {
    private let routineSettingRepository: TimerRoutineSettingRepository
    private let fastInterruptedDayRepository: FastInterruptedDayRepository
    private let userNotificationManager: UserNotificationManager
    private let disposeBag: DisposeBag
    
    init(
        routineSettingRepository: TimerRoutineSettingRepository,
        fastInterruptedDayRepository: FastInterruptedDayRepository,
        userNotificationManager: UserNotificationManager
    ) {
        self.routineSettingRepository = routineSettingRepository
        self.fastInterruptedDayRepository = fastInterruptedDayRepository
        self.userNotificationManager = userNotificationManager
        self.disposeBag = DisposeBag()
    }
    
    deinit {
        Log.deinit()
    }
    
    func fetchTimerRoutine() -> Single<TimerRoutineSetting?> {
        return routineSettingRepository.fetchRoutine()
    }
    
    func saveRoutineSetting(with routineSetting: TimerRoutineSetting, isDeleteInterruptedDay: Bool) -> Single<TimerRoutineSetting> {
        removePreviousFastNotifications()
            .flatMap { [unowned self] _ in
                var tasks = [
                    self.scheduleNotifications(routineSetting: routineSetting).map { _ in },
                    self.routineSettingRepository.update(routineSetting: routineSetting).map { _ in },
                    UserDefaultsManager.save(routineSetting: routineSetting).map { _ in }
                ]
                if isDeleteInterruptedDay {
                    tasks.append(self.fastInterruptedDayRepository.deleteInterruptedDay().map { _ in })
                }
                return Single
                    .zip(tasks)
                    .map { _ in routineSetting }
            }
    }
    
    func deleteRoutineSetting() -> Single<Void> {
        return Single.zip(
            routineSettingRepository.deleteRoutine(),
            userNotificationManager.removeNotifications(type: .fastEnd),
            userNotificationManager.removeNotifications(type: .fastStart)
        )
        .map { _ in }
    }
    
    func interruptFast(currentFastEndDate: Date, interruptedDate: Date) -> Single<InterruptedFast> {
        let id = LocalNotificationType.fastEnd.fastNotificationID(date: currentFastEndDate)
        return Single.zip(
            userNotificationManager.removeNotification(ids: [id]),
            fastInterruptedDayRepository.update(interruptedFastDate: interruptedDate, interruptedFastEndDate: currentFastEndDate)
        )
        .map { $0.1 }
    }
    
    func fetchInterruptedFastDate() -> Single<InterruptedFast?> {
        return fastInterruptedDayRepository.fetchInterruptedDay()
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
