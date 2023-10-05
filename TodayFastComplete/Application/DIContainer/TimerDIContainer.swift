//
//  TimerDIContainer.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/2/23.
//

import UIKit

final class TimerDIContainer: TimerCoordinatorDependencies {
    
    // MARK: - Coordinator
    func makeSettingTimerCoordinator(
        rootViewController: UINavigationController,
        finishDelegate: CoordinatorFinishDelegate
    ) -> Coordinator {
        return SettingTimerCoordinator(
            rootViewController: rootViewController,
            dependencies: SettingTimerDIContainer(),
            finishDelegate: finishDelegate
        )
    }
    
    // MARK: - Timer View
    func makeTimerViewController(coordinator: Coordinator) -> UIViewController {
        return TimerViewController(viewModel: makeTimerViewModel(coordinator: coordinator))
    }
    
    private func makeTimerViewModel(coordinator: Coordinator) -> TimerViewModel {
        return TimerViewModel(coordinator: coordinator)
    }
}
