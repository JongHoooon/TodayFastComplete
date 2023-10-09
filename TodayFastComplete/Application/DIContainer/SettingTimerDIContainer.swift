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
        selectedStartTime: PublishRelay<Date>
    ) -> UIViewController {
        return StartTimerPickerViewController(viewModel: makeStartTimePickerViewModel(
            coordinator: coordinator,
            selectedStartTime: selectedStartTime
        ))
    }
    
    private func makeStartTimePickerViewModel(
        coordinator: Coordinator,
        selectedStartTime: PublishRelay<Date>
    ) -> StartTimePickerViewModel {
        return StartTimePickerViewModel(
            coordinator: coordinator,
            selectedStartTime: selectedStartTime
        )
    }
}
