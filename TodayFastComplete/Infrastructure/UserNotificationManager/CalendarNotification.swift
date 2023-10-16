//
//  LocalNotification.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/13/23.
//

import Foundation

struct CalendarNotification {
    let type: LocalNotificationType
    let id: String
    let title: String
    let subtitle: String? = nil
    let body: String
    let dateComponents: DateComponents

    init(
        type: LocalNotificationType,
        title: String,
        body: String,
        year: Int,
        month: Int,
        day: Int,
        hour: Int,
        minute: Int
    ) {
        self.type = type
        self.id = type.fastNotificationID(
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute
        )
        self.title = title
        self.body = body
        self.dateComponents = DateComponents(
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute
        )
    }
}
