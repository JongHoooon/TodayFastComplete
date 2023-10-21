//
//  AppDelegate.swift
//  TodayFastComplete
//
//  Created by JongHoon on 2023/09/26.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        configureLocalNotification()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        
        return UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )
    }

    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {

    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
        
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        return [.sound, .badge, .banner, .list]
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        postNotification(with: response.notification.request.identifier)
    }
}

private extension AppDelegate {
    func configureLocalNotification() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current()
            .requestAuthorization(
                options: [.alert, .sound, .badge],
                completionHandler: { success, error in
                    if let error {
                        Log.error(error)
                    } else if success == true {
                        Log.info("request authorization authorized")
                    } else {
                        Log.info("request authorization rejected")
                    }
                }
            )
    }
    
    func postNotification(with id: String) {
        guard let localNotificationType = LocalNotificationType(with: id) else { return }
        NotificationCenter.default.post(
            name: .localNotificationType,
            object: nil,
            userInfo: [NotificationUserInfoKey.localNotificationType.rawValue: localNotificationType]
        )
        Log.debug("app delegate noti")
    }
}
