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
    
    let window: UIWindow
    let dependencies: TabBarDependencies
    
    init(
        window: UIWindow,
        dependencies: TabBarDependencies,
        finishDelegate: CoordinatorFinishDelegate
    ) {
        self.window = window
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
        
        let tabBarController = dependencies.makeTabBarController()
        tabBarController.setViewControllers([timerNavigationController], animated: true)
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = .fade
        transition.timingFunction = CAMediaTimingFunction(
            name: CAMediaTimingFunctionName.easeInEaseOut
        )
        window.layer.add(transition, forKey: kCATransition)
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}
