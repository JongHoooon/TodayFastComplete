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
    }
    
    func removeNotification(ids: [String]) -> Single<Void> {
        return Single.create { [weak self] single in
            self?.center.removePendingNotificationRequests(withIdentifiers: ids)
            single(.success(Void()))
            
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
}
