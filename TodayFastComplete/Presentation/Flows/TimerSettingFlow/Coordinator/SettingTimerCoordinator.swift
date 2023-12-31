//
//  SettingTimerCoordinator.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/5/23.
//

import UIKit

import RxSwift
import RxRelay

protocol SettingTimerDependencies {
    func makeSelectFastModeViewController(coordinator: Coordinator) -> UIViewController
    func makeSettingRoutineViewController(
        coordinator: Coordinator,
        currentRoutineSetting: BehaviorRelay<TimerRoutineSetting?>,
        interruptedFast: BehaviorRelay<InterruptedFast?>
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

final class SettingTimerCoordinator: BaseCoordinator, CancelOkAlertPresentable {
    
    enum PresentedView {
        case startTimePicker
        case fastTimePicker
    }
    
    let rootViewController: UINavigationController
    let dependencies: SettingTimerDependencies
    private var presentedViews: [PresentedView: UIViewController] = [:]
    private let disposeBag = DisposeBag()
        
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
        case let .settingTimerFlowIsRequired(currentRoutineSetting, interruptedFast):
            showSettingRoutine(
                currentRoutineSetting: currentRoutineSetting,
                interruptedFast: interruptedFast
            )
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
        case let .settingDeleteRoutineSettingButtonTapped(deleteAlertActionRelay):
            presentDeleteRoutineSettingAlert(deleteAlertActionRelay: deleteAlertActionRelay)
        default:
            assertionFailure("not configured step")
        }
    }
    
    override func finish() {
        if let vc = rootViewController.presentedViewController {
            vc.dismiss(animated: true)
        }
        rootViewController.dismiss(animated: true)
        super.finish()
    }
}

private extension SettingTimerCoordinator {
    /*
    func showSelectTimerMode() {
        let selectTimerVC = dependencies.makeSelectFastModeViewController(coordinator: self)
        rootViewController.viewControllers = [selectTimerVC]
    }
    */
    
    func showSettingRoutine(
        currentRoutineSetting: BehaviorRelay<TimerRoutineSetting?>,
        interruptedFast: BehaviorRelay<InterruptedFast?>
    ) {
        let settingRoutineVC = dependencies.makeSettingRoutineViewController(
            coordinator: self,
            currentRoutineSetting: currentRoutineSetting,
            interruptedFast: interruptedFast
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
    
    func presentDeleteRoutineSettingAlert(deleteAlertActionRelay: PublishRelay<AlertActionType>) {
        presentCancelOkAlert(
            navigationController: rootViewController,
            message: Constants.Localization.DELETE_FAST_ALERT_MESSAGE,
            okTitle: Constants.Localization.DO_DELETE
        )
        .bind { deleteAlertActionRelay.accept($0) }
        .disposed(by: disposeBag)
    }
}
