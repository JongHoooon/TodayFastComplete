//
//  AppDIContainer.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/2/23.
//

import UIKit

final class AppDIContainer: AppCoordinatorDependencies {
        
    // MARK: - Tab Bar Coordinator
    func makeTabBarCoordinator(window: UIWindow) -> Coordinator {
        return TabBarCoordinator(
            window: window,
            dependencies: TabBarDIContainer()
        )
    }
}
