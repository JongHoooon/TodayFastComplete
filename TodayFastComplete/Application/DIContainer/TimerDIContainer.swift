//
//  TimerDIContainer.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/2/23.
//

import UIKit

final class TimerDIContainer: TimerCoordinatorDependencies {
    
    // MARK: - Use Case
    private func makeTimerUseCase() -> TimerUseCase {
        return TimerUseCaseImp(
            routineSettingRepository: makeTimerRoutineSettingRepostory(),
            userNotificationManager: DefaultUserNotificationManager()
        )
    }
                                                 
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
    // MARK: - Coordinator
    func makeSettingTimerCoordinator(
        rootViewController: UINavigationController,
        finishDelegate: CoordinatorFinishDelegate
    ) -> Coordinator {
        return SettingTimerCoordinator(
            rootViewController: rootViewController,
            dependencies: SettingTimerDIContainer(),
            finishDelegate: finishDelegate
        )
    }
    
    // MARK: - Timer View
    func makeTimerViewController(coordinator: Coordinator) -> UIViewController {
        return TimerViewController(viewModel: makeTimerViewModel(coordinator: coordinator))
    }
    
    private func makeTimerViewModel(coordinator: Coordinator) -> TimerViewModel {
        return TimerViewModel(
            timerViewUseCase: makeTimerUseCase(),
            coordinator: coordinator
        )
    }
}
