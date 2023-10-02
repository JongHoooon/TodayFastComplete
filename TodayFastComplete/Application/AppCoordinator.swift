//
//  AppCoordinator.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/2/23.
//

import UIKit

protocol AppCoordinatorDependencies {
    func makeTabBarCoordinator(window: UIWindow) -> Coordinator
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
    
    override func start() {
        showTabBarScene()
    }
    
    private func showTabBarScene() {
        let tabBarCoordinator = dependencies.makeTabBarCoordinator(window: window)
        tabBarCoordinator.finishDelegate = self
        tabBarCoordinator.start()
        addChild(child: tabBarCoordinator)
    }
}
