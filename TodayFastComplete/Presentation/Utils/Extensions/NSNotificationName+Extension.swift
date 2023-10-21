//
//  NSNotificationName+Extension.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/14/23.
//

import Foundation

extension NSNotification.Name {
    static let sceneWillEnterForeground = NSNotification.Name("sceneWillEnterForeground")
    static let localNotificationType = NSNotification.Name("localNotificationType")
}

enum NotificationUserInfoKey: String {
    case localNotificationType
}
