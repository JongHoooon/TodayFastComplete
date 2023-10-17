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
        case .appFlowIsRequired:
            navigate(to: .tabBarFlowIsRequired)
        case .tabBarFlowIsRequired:
            showTabBarScene()
        default:
            assertionFailure("not configured step")
        }
    }
    
    private func showTabBarScene() {
        let tabBar = dependencies.makeTabBarController()
        let tabBarCoordinator = dependencies.makeTabBarCoordinator(
            rootViewController: tabBar,
            finishDelegate: self
        )
        addChild(child: tabBarCoordinator)
        tabBarCoordinator.navigate(to: .tabBarFlowIsRequired)
        window.rootViewController = tabBar
        window.makeKeyAndVisible()
    }
}
