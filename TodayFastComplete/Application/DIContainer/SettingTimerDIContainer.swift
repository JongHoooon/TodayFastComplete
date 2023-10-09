//
//  SettingTimerDIContainer.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/5/23.
//

import UIKit

import RxRelay

final class SettingTimerDIContainer: SettingTimerDependencies {
    
    // MARK: - Select Fast Mode View
    func makeSelectFastModeViewController(coordinator: Coordinator) -> UIViewController {
        return SelectFastModeViewController(viewModel: makeSelectFastModeViewModel(coordinator: coordinator))
    }
    
    private func makeSelectFastModeViewModel(coordinator: Coordinator) -> SelectFastModeViewModel {
        return SelectFastModeViewModel(coordinator: coordinator)
    }
    
    // MARK: - Setting Routine View
    func makeSettingRoutineViewController(coordinator: Coordinator) -> UIViewController {
        return SettingRoutineViewController(viewModel: makeSettingRoutineViewModel(coordinator: coordinator))
    }
    
    private func makeSettingRoutineViewModel(coordinator: Coordinator) -> SettingRoutineViewModel {
        return SettingRoutineViewModel(coordinator: coordinator)
    }
    
    // MARK: - Start Time Picker View
    func makeStartTimePickerViewController(
        coordinator: Coordinator,
        selectedStartTime: BehaviorRelay<String>
    ) -> UIViewController {
        return StartTimerPickerViewController(viewModel: makeStartTimePickerViewModel(
            coordinator: coordinator,
            selectedStartTime: selectedStartTime
        ))
    }
    
    private func makeStartTimePickerViewModel(
        coordinator: Coordinator,
        selectedStartTime: BehaviorRelay<String>
    ) -> StartTimePickerViewModel {
        return StartTimePickerViewModel(
            coordinator: coordinator,
            selectedStartTime: selectedStartTime
        )
    }
    
    // MARK: - Fast Time Picker View
    func makeFastTimePickerViewController(
        coordinator: Coordinator,
        selectedFastTime: BehaviorRelay<String>
    ) -> UIViewController {
        return FastTimePickerViewController(viewModel: makeFastTimePickerViewModel(
            coordinator: coordinator,
            selectedFastTime: selectedFastTime
        ))
    }
    
    private func makeFastTimePickerViewModel(
        coordinator: Coordinator,
        selectedFastTime: BehaviorRelay<String>
    ) -> FastTimePickerViewModel {
        return FastTimePickerViewModel(
            coordinator: coordinator,
            selectedFastTime: selectedFastTime
        )
    }
}
