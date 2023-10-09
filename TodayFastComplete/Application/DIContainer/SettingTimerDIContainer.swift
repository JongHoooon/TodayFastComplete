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
        selectedStartTime: BehaviorRelay<Date>,
        initialStartTime: Date
    ) -> UIViewController {
        return StartTimerPickerViewController(viewModel: makeStartTimePickerViewModel(
            coordinator: coordinator,
            selectedStartTime: selectedStartTime, 
            initialStartTime: initialStartTime
        ))
    }
    
    private func makeStartTimePickerViewModel(
        coordinator: Coordinator,
        selectedStartTime: BehaviorRelay<Date>,
        initialStartTime: Date
    ) -> StartTimePickerViewModel {
        return StartTimePickerViewModel(
            coordinator: coordinator,
            selectedStartTime: selectedStartTime, 
            initialStartTime: initialStartTime
        )
    }
    
    // MARK: - Fast Time Picker View
    func makeFastTimePickerViewController(
        coordinator: Coordinator,
        selectedFastTime: BehaviorRelay<Int>,
        recommendSectionNeedDeselect: PublishRelay<Void>,
        initialFastTime: Int
    ) -> UIViewController {
        return FastTimePickerViewController(viewModel: makeFastTimePickerViewModel(
            coordinator: coordinator,
            selectedFastTime: selectedFastTime, 
            recommendSectionNeedDeselect: recommendSectionNeedDeselect, 
            initialFastTime: initialFastTime
        ))
    }
    
    private func makeFastTimePickerViewModel(
        coordinator: Coordinator,
        selectedFastTime: BehaviorRelay<Int>,
        recommendSectionNeedDeselect: PublishRelay<Void>,
        initialFastTime: Int
    ) -> FastTimePickerViewModel {
        return FastTimePickerViewModel(
            coordinator: coordinator,
            selectedFastTime: selectedFastTime, 
            recommendSectionNeedDeselect: recommendSectionNeedDeselect, 
            initialFastTime: initialFastTime
        )
    }
}
