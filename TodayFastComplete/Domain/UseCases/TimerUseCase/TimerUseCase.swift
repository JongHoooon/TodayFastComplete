//
//  TimerUseCaseImp.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/9/23.
//

import Foundation

import UIKit

import RxSwift

typealias TimerUseCase = RoutineSettingFetchable & RoutineSettingSaveable

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
}

private extension TimerUseCaseImp {
    func scheduleNotifications(routineSetting: TimerRoutineSetting) -> Single<Void> {
        return userNotificationManager.pendingNotificationCount()
            .map { Constants.DefaultValue.localNotificationMaxCount - $0 - 4 }
            .map { [weak self] maxCount -> [CalendarNotification] in
                guard let self else { return [] }
                let datesForNotification = datesForNotification(
                    maxCount: maxCount,
                    days: routineSetting.days
                )
                let fastStartNotifications = fastStartNotifications(
                    dates: datesForNotification,
                    startTimeHour: routineSetting.startTime.hour ?? 0,
                    startTimeMinute: routineSetting.startTime.minute ?? 0,
                    fastTime: routineSetting.fastTime
                )
                let fastEndNotifications = fastEndNotifications(
                    dates: datesForNotification,
                    startTimeHour: routineSetting.startTime.hour ?? 0,
                    startTimeMinute: routineSetting.startTime.minute ?? 0,
                    fastTime: routineSetting.fastTime
                )
                return fastStartNotifications+fastEndNotifications
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
    
    func datesForNotification(
        maxCount: Int, days: [Int]
    ) -> [Date] {
        let maxWeekCount = min(maxCount / (days.count * 2), 2)
        let current = Date()
        let currentWeek = days
            .map { Calendar.current.date(bySetting: .weekday, value: $0, of: current) }
            .compactMap { $0 }
        var datesForNotification = currentWeek
        for i in 1..<maxWeekCount {
            let days = currentWeek
                .map { Calendar.current.date(byAdding: .weekdayOrdinal, value: i, to: $0) }
                .compactMap { $0 }
            datesForNotification += days
        }
        
        return datesForNotification
    }
    
    func fastStartNotifications(
        dates: [Date],
        startTimeHour: Int,
        startTimeMinute: Int,
        fastTime: Int
    ) -> [CalendarNotification] {
        return dates.map { fastStartDate in
            return CalendarNotification(
                type: .fastStart,
                title: String(
                    localized: "FAST_START_NOTI_TITLE",
                    defaultValue: "단식이 시작됐습니다.🍚🍜🍔❌"
                ),
                body: String(
                    localized: "FAST_START_NOTI_BODY",
                    defaultValue: "지금부터 \(fastTime)시간 동안 단식 시간입니다."
                ),
                year: fastStartDate.year,
                month: fastStartDate.month,
                day: fastStartDate.day,
                hour: startTimeHour,
                minute: startTimeMinute
            )
        }
    }
    
    func fastEndNotifications(
        dates: [Date],
        startTimeHour: Int,
        startTimeMinute: Int,
        fastTime: Int
    ) -> [CalendarNotification] {
        return dates
            .compactMap { date in
                return Calendar.current.date(from: DateComponents(
                    year: date.year,
                    month: date.month,
                    day: date.day,
                    hour: startTimeHour + fastTime,
                    minute: startTimeMinute
                ))}
            .map { fastEndDate in
                return CalendarNotification(
                    type: .fastStart,
                    title: String(
                        localized: "FAST_END_NOTI_TITLE",
                        defaultValue: "단식이 종료됐습니다👍"
                    ),
                    body: String(
                        localized: "FAST_END_NOTI_BODY",
                        defaultValue: "고생하셨습니다! 앱으로 돌아와서 단식 정보를 기록해주세요🤗"
                    ),
                    year: fastEndDate.year,
                    month: fastEndDate.month,
                    day: fastEndDate.day,
                    hour: fastEndDate.hour,
                    minute: fastEndDate.minute
                )
            }
    }
}

/*
 알람 등록, 전부 삭제해야됨
 week days 기반으로 알림 등록
 
 시작알림 끝 알림
 
 */
