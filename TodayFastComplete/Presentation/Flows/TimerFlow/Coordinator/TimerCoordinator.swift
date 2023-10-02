//
//  TimerCoordinator.swift
//  TodayFastComplete
//
//  Created by JongHoon on 9/30/23.
//

import UIKit

protocol TimerCoordinatorDependencies {
    func makeTimerViewController() -> UIViewController
}

final class DefaultTimerCoordinator: BaseCoordinator {
    
    let navigationController: UINavigationController
    let dependencies: TimerCoordinatorDependencies
    
    init(
        navigationController: UINavigationController,
        dependencies: TimerCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    deinit {
        Log.deinit()
    }
    
    override func start() {
        showTimer()
    }
    
    private func showTimer() {
        let vc = dependencies.makeTimerViewController()
        navigationController.setViewControllers([vc], animated: true)
    }
}
