//
//  TimerDIContainer.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/2/23.
//

import UIKit

final class TimerDIContainer: TimerCoordinatorDependencies {
    
    // MARK: - Timer View
    func makeTimerViewController(coordinator: Coordinator) -> UIViewController {
        return TimerViewController(viewModel: makeTimerViewModel(coordinator: coordinator))
    }
    
    private func makeTimerViewModel(coordinator: Coordinator) -> TimerViewModel {
        return TimerViewModel(coordinator: coordinator)
    }
    
    // MARK: - Select Fast Mode View
    func makeSelectFastModeViewController(coordinator: Coordinator) -> UIViewController {
        return SelectFastModeViewController(viewModel: makeSelectFastModeViewModel(coordinator: coordinator))
    }
    
    private func makeSelectFastModeViewModel(coordinator: Coordinator) -> SelectFastModeViewModel {
        return SelectFastModeViewModel(coordinator: coordinator)
    }
}
