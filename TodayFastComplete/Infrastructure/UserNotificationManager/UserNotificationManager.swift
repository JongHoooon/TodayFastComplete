//
//  UserNotificationManager.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/13/23.
//

import UIKit

import RxSwift

protocol UserNotificationManager {
    func schedule(calendarNotification: CalendarNotification) -> Single<Void>
    func schedule(calendarNotifications: [CalendarNotification]) -> Single<Void>
    func removeNotifications(type: LocalNotificationType) -> Single<Void>
    func removeNotification(ids: [String]) -> Single<Void>
    func pendingNotificationCount() -> Single<Int>
    func pendingNotificationCount(type: LocalNotificationType) -> Single<Int>
    func fastNotifications(maxCount: Int, fastDays: [Int], routineSetting: TimerRoutineSetting) -> [CalendarNotification]
}

final class DefaultUserNotificationManager: UserNotificationManager {
    private let center = UNUserNotificationCenter.current()
    
    func schedule(calendarNotification: CalendarNotification) -> Single<Void> {
        return Single.create { [weak self] single in
            let content = UNMutableNotificationContent()
            content.title = calendarNotification.title
            if let subtitle = calendarNotification.subtitle {
                content.subtitle = subtitle
            }
            content.body = calendarNotification.body
            content.sound = .default
            content.badge = 1
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: calendarNotification.dateComponents,
                repeats: false
            )
            let request = UNNotificationRequest(
                identifier: calendarNotification.id,
                content: content,
                trigger: trigger
            )
            self?.center.add(request, withCompletionHandler: { error in
                if let error {
                    single(.failure(error))
                } else {
                    single(.success(Void()))
                    Log.debug(request)
                }
            })
            
            return Disposables.create()
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
    }
    
    func schedule(calendarNotifications: [CalendarNotification]) -> Single<Void> {
        return Single
            .zip(calendarNotifications.map { schedule(calendarNotification: $0) })
            .map { _ in }
            .subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
    }
    
    func removeNotifications(type: LocalNotificationType) -> Single<Void> {
        return pendingNotifications()
            .map { requests in
                return requests
                    .filter { ($0.identifier.split(separator: "-").first ?? "") == type.rawValue }
                    .map { $0.identifier }
            }
            .flatMap { [unowned self] filteredIDs in
                return self.removeNotification(ids: filteredIDs)
            }
            .map { _ in }
            .subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
    }
    
    func removeNotification(ids: [String]) -> Single<Void> {
        return Single.create { [weak self] single in
            #if DEBUG
            UNUserNotificationCenter.current().getPendingNotificationRequests { request in
                Log.debug("before delete noti count: \(request.map { $0.identifier }.count)")
            }
            #endif
            self?.center.removePendingNotificationRequests(withIdentifiers: ids)
            single(.success(Void()))
            Log.debug(ids)
            #if DEBUG
            UNUserNotificationCenter.current().getPendingNotificationRequests { request in
                Log.debug("after delete noti count: \(request.map { $0.identifier }.count)")
            }
            #endif
            return Disposables.create()
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
    }
    
    func pendingNotifications() -> Single<[UNNotificationRequest]> {
        return Single.create { [weak self] single in
            self?.center.getPendingNotificationRequests(completionHandler: { requests in
                single(.success(requests))
            })
            return Disposables.create()
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
    }
    
    func pendingNotificationCount() -> Single<Int> {
        return Single.create { [weak self] single in
            self?.center.getPendingNotificationRequests(completionHandler: { requests in
                single(.success(requests.count))
            })
            return Disposables.create()
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
    }
    
    func pendingNotificationCount(type: LocalNotificationType) -> Single<Int> {
        return Single.create { [weak self] single in
            self?.center.getPendingNotificationRequests(completionHandler: { requests in
                let filteredRequests = requests.filter { ($0.identifier.split(separator: "-").first ?? "") == type.rawValue }
                single(.success(filteredRequests.count))
            })
            return Disposables.create()
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
    }
    
    func fastNotifications(
        maxCount: Int,
        fastDays: [Int],
        routineSetting: TimerRoutineSetting
    ) -> [CalendarNotification] {
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
        var notifications = (fastStartNotifications + fastEndNotifications)
            .sorted {
                guard let firstDate = Calendar.current.date(from: $0.dateComponents),
                      let secondDate = Calendar.current.date(from: $1.dateComponents)
                else {
                    return false
                }
                return firstDate.compare(secondDate) == .orderedAscending
            }
        if notifications.count > maxCount {
            notifications = Array(notifications.prefix(maxCount))
        }
        Log.debug(notifications)
        return notifications
    }
    
    func datesForNotification(
        maxCount: Int, days: [Int]
    ) -> [Date] {
        let maxWeekCount = min(maxCount / (days.count * 2), 2)
        let current = Date().addingTimeInterval(-24*3600)
        let currentWeek = days
            .map { Calendar.current.date(bySetting: .weekday, value: $0, of: current) }
            .compactMap { $0 }
        var datesForNotification = currentWeek
        guard 1 <= maxWeekCount 
        else {
            assertionFailure("max week count smaller than 1")
            return []
        }
        for i in 1..<maxWeekCount {
            let days = currentWeek
                .map { Calendar.current.date(byAdding: .weekdayOrdinal, value: i, to: $0) }
                .compactMap { $0 }
            datesForNotification += days
        }
        
        return datesForNotification
    }
    
    private func fastStartNotifications(
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
    
    private func fastEndNotifications(
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
                    type: .fastEnd,
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
