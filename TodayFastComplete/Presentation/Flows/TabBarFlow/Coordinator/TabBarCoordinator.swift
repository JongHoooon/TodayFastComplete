//
//  TabBarCoordinator.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/2/23.
//

import UIKit

protocol TabBarDependencies {
    func makeTabBarController() -> UITabBarController
    func makeTimerCoordinator(navigationController: UINavigationController) -> Coordinator
}

final class TabBarCoordinator: BaseCoordinator, CoordinatorFinishDelegate {
    
    let window: UIWindow
    let dependencies: TabBarDependencies
    
    init(
        window: UIWindow,
        dependencies: TabBarDependencies
    ) {
        self.window = window
        self.dependencies = dependencies
    }
    
    deinit {
        Log.deinit()
    }
    
    override func start() {
        showTabBar()
    }
    
    private func showTabBar() {
        let timerNavigationController = TabBarEnum.timer.rootNavigationController
        let timerCoordinator = dependencies.makeTimerCoordinator(navigationController: timerNavigationController)
        timerCoordinator.finishDelegate = self
        timerCoordinator.start()
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
