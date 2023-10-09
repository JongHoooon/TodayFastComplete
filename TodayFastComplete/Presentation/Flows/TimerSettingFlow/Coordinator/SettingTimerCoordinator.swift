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
    func makeSettingRoutineViewController(coordinator: Coordinator) -> UIViewController
    func makeStartTimePickerViewController(coordinator: Coordinator, selectedStartTime: BehaviorRelay<String>) -> UIViewController
    func makeFastTimePickerViewController(coordinator: Coordinator, selectedFastTime: BehaviorRelay<String>) -> UIViewController
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
        case .settingTimerFlowIsRequired:
            showSettingRoutine()
        case .settingTimerFlowIsComplete:
            rootViewController.dismiss(animated: true)
        case .settingStartTimePickerViewTapped(let selectedStartTime):
            presentStartTimePicker(selectedStartTime: selectedStartTime)
        case .settingStartTimePickerViewIsComplete:
            dismissStartTimePicker()
        case .settingFastTimePickerViewTapped(let selectedFastTime):
            presentFastTimePicker(selectedFastTime: selectedFastTime)
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
    
    func showSettingRoutine() {
        let settingRoutineVC = dependencies.makeSettingRoutineViewController(coordinator: self)
        rootViewController.viewControllers = [settingRoutineVC]
    }
    
    func presentStartTimePicker(selectedStartTime: BehaviorRelay<String>) {
        let startTimePicerVC = dependencies.makeStartTimePickerViewController(
            coordinator: self,
            selectedStartTime: selectedStartTime
        )
        rootViewController.present(startTimePicerVC, animated: true)
        presentedViews[.startTimePicker] = startTimePicerVC
    }
    
    func dismissStartTimePicker() {
        let vc = presentedViews[.startTimePicker]
        vc?.dismiss(animated: true)
        presentedViews.removeValue(forKey: .startTimePicker)
    }
    
    func presentFastTimePicker(selectedFastTime: BehaviorRelay<String>) {
        let fastTimePicerVC = dependencies.makeFastTimePickerViewController(
            coordinator: self,
            selectedFastTime: selectedFastTime
        )
        rootViewController.present(fastTimePicerVC, animated: true)
        presentedViews[.fastTimePicker] = fastTimePicerVC
    }
    
    func dismissFastTimePicker() {
        let vc = presentedViews[.fastTimePicker]
        vc?.dismiss(animated: true)
        presentedViews.removeValue(forKey: .fastTimePicker)
    }
}
