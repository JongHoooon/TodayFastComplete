//
//  AppDIContainer.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/2/23.
//

import UIKit

final class AppDIContainer: AppCoordinatorDependencies {
        
    // MARK: - Tab Bar Coordinator
    func makeTabBarCoordinator(
        rootViewController: UITabBarController,
        finishDelegate: CoordinatorFinishDelegate
    ) -> Coordinator {
        return TabBarCoordinator(
            rootViewController: rootViewController,
            dependencies: TabBarDIContainer(),
            finishDelegate: finishDelegate
        )
    }
    
    func makeTabBarController() -> UITabBarController {
        return TabBarController()
    }
}
