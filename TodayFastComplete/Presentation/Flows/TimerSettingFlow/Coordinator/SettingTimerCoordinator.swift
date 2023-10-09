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
    func makeStartTimePickerViewController(coordinator: Coordinator, selectedStartTime: PublishRelay<Date>) -> UIViewController
}

final class SettingTimerCoordinator: BaseCoordinator {
    
    enum PresentedView {
        case startTimePicker
        case fastTimePicer
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
    
    func presentStartTimePicker(selectedStartTime: PublishRelay<Date>) {
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
}
