//
//  TabBarCoordinator.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/2/23.
//

import UIKit

protocol TabBarDependencies {
    func makeTabBarController() -> UITabBarController
    func makeTimerCoordinator(navigationController: UINavigationController, finishDelegate: CoordinatorFinishDelegate) -> Coordinator
}

final class TabBarCoordinator: BaseCoordinator, CoordinatorFinishDelegate {
    
    private let rootViewController: UITabBarController
    private let dependencies: TabBarDependencies
    
    init(
        rootViewController: UITabBarController,
        dependencies: TabBarDependencies,
        finishDelegate: CoordinatorFinishDelegate
    ) {
        self.rootViewController = rootViewController
        self.dependencies = dependencies
        super.init()
        self.finishDelegate = finishDelegate
    }
    
    deinit {
        Log.deinit()
    }
    
    override func navigate(to step: Step) {
        switch step {
        case .tabBarFlowIsRequired:
            showTabBar()
        default:
            assertionFailure("not configured step")
        }
    }
    
    private func showTabBar() {
        let timerNavigationController = TabBarEnum.timer.rootNavigationController
        let timerCoordinator = dependencies.makeTimerCoordinator(
            navigationController: timerNavigationController,
            finishDelegate: self
        )
        timerCoordinator.navigate(to: .timerFlowIsRequired)
        addChild(child: timerCoordinator)
        
        rootViewController.setViewControllers([timerNavigationController], animated: true)
    }
}
