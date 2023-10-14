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
        
        // 알림 권한 설정
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
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            
            // 특정 화면, 특정 조건에서만 포그라운드 알림 받기,
            // 특정 화면에서는 알림 안받기
            completionHandler([.sound, .badge, .banner, .list])
        }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        
        print(response.notification.request.identifier)
        print(response.notification.request.content.userInfo)
        print(response.notification.date.toString(format: .dateTimeFormat))
        
        if response.notification.request.identifier == "" {
            print("deep link!")
        }
    }
}
