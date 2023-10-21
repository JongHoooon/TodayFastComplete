//
//  AppCoordinator.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/2/23.
//

import UIKit

protocol AppCoordinatorDependencies {
    func makeTabBarController() -> UITabBarController
    func makeTabBarCoordinator(rootViewController: UITabBarController, finishDelegate: CoordinatorFinishDelegate) -> Coordinator
}

final class AppCoordinator: BaseCoordinator, CoordinatorFinishDelegate {
    
    private let window: UIWindow
    private let dependencies: AppCoordinatorDependencies
    
    init(
        window: UIWindow,
        dependencies: AppCoordinatorDependencies
    ) {
        self.window = window
        self.dependencies = dependencies
    }
    
    deinit {
        Log.deinit()
    }
    
    override func navigate(to step: Step) {
        switch step {
        case let .appFlowIsRequired(notificationType):
            let tabBarIndex = notificationType?.tabBarIndex ?? 0
            navigate(to: .tabBarFlowIsRequired(tabBarIndex: tabBarIndex))
        case let .tabBarFlowIsRequired(tabBarIndex):
            showTabBarScene(tabBarIndex: tabBarIndex)
        default:
            assertionFailure("not configured step")
        }
    }
    
    private func showTabBarScene(tabBarIndex: Int) {
        let tabBar = dependencies.makeTabBarController()
        let tabBarCoordinator = dependencies.makeTabBarCoordinator(
            rootViewController: tabBar,
            finishDelegate: self
        )
        addChild(child: tabBarCoordinator)
        tabBarCoordinator.navigate(to: .tabBarFlowIsRequired(tabBarIndex: tabBarIndex))
        window.rootViewController = tabBar
        window.makeKeyAndVisible()
    }
}
