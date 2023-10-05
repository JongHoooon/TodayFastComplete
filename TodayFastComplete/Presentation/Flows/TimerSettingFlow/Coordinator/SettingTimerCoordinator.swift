//
//  SettingTimerCoordinator.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/5/23.
//

import UIKit

protocol SettingTimerDependencies {
    func makeSelectFastModeViewController(coordinator: Coordinator) -> UIViewController
}

final class SettingTimerCoordinator: BaseCoordinator {
    
    let rootViewController: UINavigationController
    let dependencies: SettingTimerDependencies
        
    init(
        rootViewController: UINavigationController,
        dependencies: SettingTimerDependencies,
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
        case .settingTimerFlowIsRequired:
            showSelectTimerMode()
        case .settingTimerFlowDismissButtonTapped:
            rootViewController.dismiss(animated: true)
        default:
            assertionFailure("not configured step")
        }
    }
}

private extension SettingTimerCoordinator {
    func showSelectTimerMode() {
        let selectTimerVC = dependencies.makeSelectFastModeViewController(coordinator: self)
        rootViewController.viewControllers = [selectTimerVC]
    }
}
