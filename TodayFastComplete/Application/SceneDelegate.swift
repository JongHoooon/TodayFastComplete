//
//  SceneDelegate.swift
//  TodayFastComplete
//
//  Created by JongHoon on 2023/09/26.
//

import UIKit

import RxSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var appCoordinator: Coordinator?
    private var userNotificationManager: UserNotificationManager?
    private var disposeBag = DisposeBag()

    func scene(
        _ scene: UIScene, willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        window.backgroundColor = .systemBackground
        window.tintColor = Constants.Color.tintMain
        UINavigationBar.appearance().tintColor = .label
        appCoordinator = AppCoordinator(
            window: window,
            dependencies: AppDIContainer()
        )
        if let notificationResponse = connectionOptions.notificationResponse {
            let notificationID = notificationResponse.notification.request.identifier
            let localNotificationType = LocalNotificationType(with: notificationID)
            Log.debug(localNotificationType)
            appCoordinator?.navigate(to: .appFlowIsRequired(notificationType: localNotificationType))
        } else {
            appCoordinator?.navigate(to: .appFlowIsRequired())
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) {
        updateFastNotification()
        UNUserNotificationCenter.current().setBadgeCount(0)
        NotificationCenter.default.post(name: .sceneWillEnterForeground, object: nil)
    }

    func sceneDidEnterBackground(_ scene: UIScene) { }
}

private extension SceneDelegate {
    func updateFastNotification() {
        userNotificationManager = DefaultUserNotificationManager()
        
        guard let userNotificationManager
        else {
            assertionFailure("user notification manager or timer routine setting repository is not exist")
            return
        }
        
        Single.zip(
            Observable.just(UserDefaultsManager.routineSetting).asSingle(),
            userNotificationManager.pendingNotificationCount(type: .fastStart),
            userNotificationManager.pendingNotificationCount(type: .fastEnd),
            userNotificationManager.pendingNotificationCount()
        )
        .asObservable()
        .filter { $0.0 != nil && $0.1 + $0.2 < 8 }
        .map { routinsetting, _, _, pendingNotiCount in
            return userNotificationManager.fastNotifications(
                maxCount: Constants.DefaultValue.localNotificationMaxCount - pendingNotiCount,
                fastDays: routinsetting!.days,
                routineSetting: routinsetting!
            )}
        .flatMap {
            return userNotificationManager.schedule(calendarNotifications: $0)
        }
        .subscribe(
            onNext: {
                Log.info("Fast start, end notification update success")
            },
            onError: {
                Log.error("\($0), Fast start, end notification update fail")
        })
        .disposed(by: disposeBag)
    }
}
