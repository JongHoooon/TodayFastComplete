//
//  TabBarDIContainer.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/2/23.
//

import UIKit

final class TabBarDIContainer: TabBarDependencies {
    
    // MARK: - Coordinators
    func makeTimerCoordinator(
        navigationController: UINavigationController,
        finishDelegate: CoordinatorFinishDelegate
    ) -> Coordinator {
        return DefaultTimerCoordinator(
            navigationController: navigationController,
            dependencies: TimerDIContainer(), 
            finishDelegate: finishDelegate
        )
    }
    
    // MARK: - Tab Bar
    func makeTabBarController() -> UITabBarController {
        return TabBarController()
    }
    
}
