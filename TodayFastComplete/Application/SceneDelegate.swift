//
//  SceneDelegate.swift
//  TodayFastComplete
//
//  Created by JongHoon on 2023/09/26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var appCoordinator: Coordinator?

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
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { 
        UNUserNotificationCenter.current().setBadgeCount(0)
        NotificationCenter.default.post(name: .sceneWillEnterForeground, object: nil)
    }

    func sceneDidEnterBackground(_ scene: UIScene) { }
}
