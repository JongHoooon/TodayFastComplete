//
//  LocalNotificationType.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/14/23.
//

import Foundation

enum LocalNotificationType: String {
    case fastStart
    case fastEnd
    
    func fastNotificationID(
        year: Int,
        month: Int,
        day: Int,
        hour: Int,
        minute: Int
    ) -> String {
        return "\(self.rawValue)-\(year)\(month)\(day)\(hour)\(minute)"
    }
    func fastNotificationID(date: Date) -> String {
        return "\(self.rawValue)-\(date.year)\(date.month)\(date.day)\(date.hour)\(date.minute)"
    }
}
