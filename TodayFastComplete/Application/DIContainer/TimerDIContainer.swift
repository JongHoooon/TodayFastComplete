//
//  TimerDIContainer.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/2/23.
//

import UIKit

final class TimerDIContainer: TimerCoordinatorDependencies {
    
    // MARK: - Timer View
    func makeTimerViewController() -> UIViewController {
        return TimerViewController(viewModel: makeTimerViewModel())
    }
    
    func makeTimerViewModel() -> TimerViewModel {
        return TimerViewModel()
    }
}
