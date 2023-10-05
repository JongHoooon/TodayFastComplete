//
//  TimerCoordinator.swift
//  TodayFastComplete
//
//  Created by JongHoon on 9/30/23.
//

import UIKit

protocol TimerCoordinatorDependencies {
    func makeTimerViewController(coordinator: Coordinator) -> UIViewController
    func makeSettingTimerCoordinator(rootViewController: UINavigationController, finishDelegate: CoordinatorFinishDelegate) -> Coordinator
}

final class DefaultTimerCoordinator: BaseCoordinator, CoordinatorFinishDelegate {
    
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
        case .timerSettingButtonTapped:
            presentToSelectFastMode()
        default:
            assertionFailure("not configured step")
        }
    }
    
    private func showTimer() {
        let vc = dependencies.makeTimerViewController(coordinator: self)
        navigationController.setViewControllers([vc], animated: true)
    }
    
    private func presentToSelectFastMode() {
        let settingTimerNavigationController = UINavigationController()
        let settingTimerCoordinator = dependencies.makeSettingTimerCoordinator(
            rootViewController: settingTimerNavigationController,
            finishDelegate: self
        )
        settingTimerCoordinator.navigate(to: .settingTimerFlowIsRequired)
        settingTimerNavigationController.modalPresentationStyle = .fullScreen
        navigationController.present(
            settingTimerNavigationController,
            animated: true
        )
        addChild(child: settingTimerCoordinator)
    }
}
