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
    private var timerRoutineSettingRepository: TimerRoutineSettingRepository?
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
        appCoordinator?.navigate(to: .appFlowIsRequired)
        
        Log.info(connectionOptions.notificationResponse)
        Log.info(connectionOptions.notificationResponse?.notification)
        Log.info(connectionOptions.notificationResponse?.notification.request.identifier)
        Log.info(connectionOptions.notificationResponse?.notification.date)
        Log.info(connectionOptions.notificationResponse?.notification.request.content)
        if let notificationResponse = connectionOptions.notificationResponse {
            Log.info(notificationResponse.notification.request.identifier)
        }
        Log.info("test-test-test-test")
        
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
        do {
            timerRoutineSettingRepository = try DefaultTimerRoutineSettingRepository()
        } catch {
            Log.error(error)
            fatalError("init realm repository failed")
        }
        
        guard let userNotificationManager, let timerRoutineSettingRepository
        else {
            assertionFailure("user notification manager or timer routine setting repository is not exist")
            return
        }
        
        Single.zip(
            timerRoutineSettingRepository.fetchRoutine(),
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
