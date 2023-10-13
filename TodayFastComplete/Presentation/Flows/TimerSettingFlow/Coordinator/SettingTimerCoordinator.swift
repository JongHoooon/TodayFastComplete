//
//  SettingTimerCoordinator.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/5/23.
//

import UIKit

import RxRelay

protocol SettingTimerDependencies {
    func makeSelectFastModeViewController(coordinator: Coordinator) -> UIViewController
    func makeSettingRoutineViewController(
        coordinator: Coordinator,
        currentRoutineSetting: BehaviorRelay<TimerRoutineSetting?>
    ) -> UIViewController
    func makeStartTimePickerViewController(
        coordinator: Coordinator,
        selectedStartTime: BehaviorRelay<DateComponents>,
        initialStartTime: DateComponents
    ) -> UIViewController
    func makeFastTimePickerViewController(
        coordinator: Coordinator,
        selectedFastTime: BehaviorRelay<Int>,
        recommendSectionNeedDeselect: PublishRelay<Void>,
        initialFastTime: Int
    ) -> UIViewController
}

final class SettingTimerCoordinator: BaseCoordinator {
    
    enum PresentedView {
        case startTimePicker
        case fastTimePicker
    }
    
    let rootViewController: UINavigationController
    let dependencies: SettingTimerDependencies
    private var presentedViews: [PresentedView: UIViewController] = [:]
        
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
        case let .settingTimerFlowIsRequired(currentRoutineSetting):
            showSettingRoutine(currentRoutineSetting: currentRoutineSetting)
        case .settingTimerFlowIsComplete:
            rootViewController.dismiss(animated: true)
        case let .settingStartTimePickerViewTapped(selectedStartTime, initialStartTime):
            presentStartTimePicker(
                selectedStartTime: selectedStartTime,
                initialStartTime: initialStartTime
            )
        case .settingStartTimePickerViewIsComplete:
            dismissStartTimePicker()
        case let .settingFastTimePickerViewTapped(selectedFastTime, recommendSectionNeedDeselect, initialFastTime):
            presentFastTimePicker(
                selectedFastTime: selectedFastTime,
                recommendSectionNeedDeselect: recommendSectionNeedDeselect, 
                initialFastTime: initialFastTime
            )
        case .settingFastTimePickerViewIsComplete:
            dismissFastTimePicker()
        default:
            assertionFailure("not configured step")
        }
    }
}

private extension SettingTimerCoordinator {
    /*
    func showSelectTimerMode() {
        let selectTimerVC = dependencies.makeSelectFastModeViewController(coordinator: self)
        rootViewController.viewControllers = [selectTimerVC]
    }
    */
    
    func showSettingRoutine(currentRoutineSetting: BehaviorRelay<TimerRoutineSetting?>) {
        let settingRoutineVC = dependencies.makeSettingRoutineViewController(
            coordinator: self,
            currentRoutineSetting: currentRoutineSetting
        )
        rootViewController.viewControllers = [settingRoutineVC]
    }
    
    func presentStartTimePicker(
        selectedStartTime: BehaviorRelay<DateComponents>,
        initialStartTime: DateComponents
    ) {
        let startTimePicerVC = dependencies.makeStartTimePickerViewController(
            coordinator: self,
            selectedStartTime: selectedStartTime, 
            initialStartTime: initialStartTime
        )
        rootViewController.present(startTimePicerVC, animated: true)
        presentedViews[.startTimePicker] = startTimePicerVC
    }
    
    func dismissStartTimePicker() {
        rootViewController.presentedViewController?.dismiss(animated: true)
        presentedViews.removeValue(forKey: .startTimePicker)
    }
    
    func presentFastTimePicker(
        selectedFastTime: BehaviorRelay<Int>,
        recommendSectionNeedDeselect: PublishRelay<Void>,
        initialFastTime: Int
    ) {
        let fastTimePicerVC = dependencies.makeFastTimePickerViewController(
            coordinator: self,
            selectedFastTime: selectedFastTime, 
            recommendSectionNeedDeselect: recommendSectionNeedDeselect, 
            initialFastTime: initialFastTime
        )
        rootViewController.present(fastTimePicerVC, animated: true)
        presentedViews[.fastTimePicker] = fastTimePicerVC
    }
    
    func dismissFastTimePicker() {
        rootViewController.presentedViewController?.dismiss(animated: true)
        presentedViews.removeValue(forKey: .fastTimePicker)
    }
}
