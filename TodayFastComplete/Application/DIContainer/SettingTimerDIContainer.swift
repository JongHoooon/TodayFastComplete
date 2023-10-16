//
//  SettingTimerDIContainer.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/5/23.
//

import UIKit

import RxRelay

final class SettingTimerDIContainer: SettingTimerDependencies {

    // MARK: - Use Case
    private func makeTimerUseCase() -> TimerUseCase {
        return TimerUseCaseImp(
            routineSettingRepository: makeTimerRoutineSettingRepostory(),
            fastInterruptedDayRepository: makeFastInterruptedDayRepository(),
            userNotificationManager: DefaultUserNotificationManager()
        )
    }
    
    // MARK: - Repository
    private func makeTimerRoutineSettingRepostory() -> TimerRoutineSettingRepository {
        do {
            let repository = try DefaultTimerRoutineSettingRepository()
            return repository
        } catch {
            // TODO: Error 처리 개선 필요
            Log.error(error)
            fatalError("init realm repository failed")
        }
    }
    
    private func makeFastInterruptedDayRepository() -> FastInterruptedDayRepository {
        do {
            let repository = try DefaultFastInterruptedDayRepository()
            return repository
        } catch {
            // TODO: Error 처리 개선 필요
            Log.error(error)
            fatalError("init realm repository failed")
        }
    }
    
    // MARK: - Select Fast Mode View
    func makeSelectFastModeViewController(coordinator: Coordinator) -> UIViewController {
        return SelectFastModeViewController(viewModel: makeSelectFastModeViewModel(coordinator: coordinator))
    }
    
    private func makeSelectFastModeViewModel(coordinator: Coordinator) -> SelectFastModeViewModel {
        return SelectFastModeViewModel(coordinator: coordinator)
    }
    
    // MARK: - Setting Routine View
    func makeSettingRoutineViewController(
        coordinator: Coordinator,
        currentRoutineSetting: BehaviorRelay<TimerRoutineSetting?>,
        interruptedFast: BehaviorRelay<InterruptedFast?>
    ) -> UIViewController {
        return SettingRoutineViewController(viewModel: makeSettingRoutineViewModel(
            coordinator: coordinator,
            currentRoutineSetting: currentRoutineSetting, 
            interruptedFast: interruptedFast
        ))
    }
    
    private func makeSettingRoutineViewModel(
        coordinator: Coordinator,
        currentRoutineSetting: BehaviorRelay<TimerRoutineSetting?>,
        interruptedFast: BehaviorRelay<InterruptedFast?>
    ) -> SettingRoutineViewModel {
        return SettingRoutineViewModel(
            settingTimerRoutineUseCase: makeTimerUseCase(), 
            interruptedFast: interruptedFast,
            coordinator: coordinator,
            currentRoutineSetting: currentRoutineSetting
        )
    }
    
    // MARK: - Start Time Picker View
    func makeStartTimePickerViewController(
        coordinator: Coordinator,
        selectedStartTime: BehaviorRelay<DateComponents>,
        initialStartTime: DateComponents
    ) -> UIViewController {
        return StartTimerPickerViewController(viewModel: makeStartTimePickerViewModel(
            coordinator: coordinator,
            selectedStartTime: selectedStartTime, 
            initialStartTime: initialStartTime
        ))
    }
    
    private func makeStartTimePickerViewModel(
        coordinator: Coordinator,
        selectedStartTime: BehaviorRelay<DateComponents>,
        initialStartTime: DateComponents
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
