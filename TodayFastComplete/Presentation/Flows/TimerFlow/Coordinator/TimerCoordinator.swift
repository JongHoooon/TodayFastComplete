//
//  TimerCoordinator.swift
//  TodayFastComplete
//
//  Created by JongHoon on 9/30/23.
//

import UIKit

protocol TimerCoordinatorDependencies {
    func makeTimerViewController(coordinator: Coordinator) -> UIViewController
    func makeSelectFastModeViewController(coordinator: Coordinator) -> UIViewController
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
        case .timerSelectFastModeIsRequired:
            pushToSelectFastMode()
        default:
            assertionFailure("not configured step")
        }
    }
    
    private func showTimer() {
        let vc = dependencies.makeTimerViewController(coordinator: self)
        navigationController.setViewControllers([vc], animated: true)
    }
    
    private func pushToSelectFastMode() {
        let vc = dependencies.makeSelectFastModeViewController(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
}
