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
        dependencies: TimerCoordinatorDependencies,
        finishDelegate: CoordinatorFinishDelegate
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        super.init()
        self.finishDelegate = finishDelegate
    }
    
    deinit {
        Log.deinit()
    }
    
    override func navigate(to step: Step) {
        switch step {
        case .timerFlowIsRequired:
            showTimer()
        default:
            assertionFailure("not configured step")
        }
    }
    
    private func showTimer() {
        let vc = dependencies.makeTimerViewController()
        navigationController.setViewControllers([vc], animated: true)
    }
}
