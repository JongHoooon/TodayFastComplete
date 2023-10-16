//
//  TimerCoordinator.swift
//  TodayFastComplete
//
//  Created by JongHoon on 9/30/23.
//

import UIKit

import RxRelay
import RxSwift

protocol TimerCoordinatorDependencies {
    func makeTimerViewController(coordinator: Coordinator) -> UIViewController
    func makeSettingTimerCoordinator(rootViewController: UINavigationController, finishDelegate: CoordinatorFinishDelegate) -> Coordinator
}

final class DefaultTimerCoordinator: BaseCoordinator, CoordinatorFinishDelegate, CancelOkAlertPresentable {
    
    private let navigationController: UINavigationController
    private let dependencies: TimerCoordinatorDependencies
    private let disposeBag = DisposeBag()
    
    init(
        navigationController: UINavigationController,
        dependencies: TimerCoordinatorDependencies,
        finishDelegate: CoordinatorFinishDelegate
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        super.init()
        self.finishDelegate = finishDelegate
    }
    
    deinit {
        Log.deinit()
    }
    
    override func navigate(to step: Step) {
        switch step {
        case .timerFlowIsRequired:
            showTimer()
        case let .timerSettingButtonTapped(currentRoutineSetting, interruptedFast):
            presentToSelectFastMode(
                currentRoutineSetting: currentRoutineSetting,
                interruptedFast: interruptedFast
            )
        case let .timerInterruptFastButtonTapped(interruptFastAlertRelay):
            presentInterruptFastAlert(interruptFastAlertRelay: interruptFastAlertRelay)
        default:
            assertionFailure("not configured step")
        }
    }
    
    private func showTimer() {
        let vc = dependencies.makeTimerViewController(coordinator: self)
        navigationController.setViewControllers([vc], animated: true)
    }
    
    private func presentToSelectFastMode(
        currentRoutineSetting: BehaviorRelay<TimerRoutineSetting?>,
        interruptedFast: BehaviorRelay<InterruptedFast?>
    ) {
        let settingTimerNavigationController = UINavigationController()
        let settingTimerCoordinator = dependencies.makeSettingTimerCoordinator(
            rootViewController: settingTimerNavigationController,
            finishDelegate: self
        )
        settingTimerCoordinator.navigate(to: .settingTimerFlowIsRequired(
            currentRoutineSetting: currentRoutineSetting,
            interruptedFast: interruptedFast)
        )
        settingTimerNavigationController.modalPresentationStyle = .fullScreen
        navigationController.present(
            settingTimerNavigationController,
            animated: true
        )
        addChild(child: settingTimerCoordinator)
    }
    
    private func presentInterruptFastAlert(interruptFastAlertRelay: PublishRelay<AlertActionType>) {
        presentCancelOkAlert(
            navigationController: navigationController,
            message: Constants.Localization.FINISH_FAST_ALERT_MESSAGE,
            okTitle: Constants.Localization.DO_FINISH
        )
        .bind { interruptFastAlertRelay.accept($0) }
        .disposed(by: disposeBag)
    }
}
