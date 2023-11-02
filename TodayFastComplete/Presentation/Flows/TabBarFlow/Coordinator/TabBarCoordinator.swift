//
//  TabBarCoordinator.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/2/23.
//

import UIKit

import RxSwift

protocol TabBarDependencies {
    func makeTabBarController() -> UITabBarController
    func makeTimerCoordinator(navigationController: UINavigationController, finishDelegate: CoordinatorFinishDelegate) -> Coordinator
    func makeRecordCoordinator(navigationController: UINavigationController, finishDelegate: CoordinatorFinishDelegate) -> Coordinator
}

final class TabBarCoordinator: BaseCoordinator, CoordinatorFinishDelegate {
    
    private let tabBarController: UITabBarController
    private weak var timerCoordinator: Coordinator?
    private weak var recordCoordinator: Coordinator?
    
    private let dependencies: TabBarDependencies
    private let disposeBag = DisposeBag()
    
    init(
        rootViewController: UITabBarController,
        dependencies: TabBarDependencies,
        finishDelegate: CoordinatorFinishDelegate
    ) {
        self.tabBarController = rootViewController
        self.dependencies = dependencies
        super.init()
        self.finishDelegate = finishDelegate
        addNotificationObserver()
    }
    
    deinit {
        Log.deinit()
    }
    
    override func navigate(to step: Step) {
        switch step {
        case let .tabBarFlowIsRequired(tabBarIndex):
            showTabBar(tabBarIndex: tabBarIndex)
        default:
            assertionFailure("not configured step")
        }
    }
}

private extension TabBarCoordinator {
    private func showTabBar(tabBarIndex: Int) {
        let timerNavigationController = TabBarEnum.timer.rootNavigationController
        let timerCoordinator = dependencies.makeTimerCoordinator(
            navigationController: timerNavigationController,
            finishDelegate: self
        )
        timerCoordinator.navigate(to: .timerFlowIsRequired)
        self.timerCoordinator = timerCoordinator
        addChild(child: timerCoordinator)
        
        let recordNavigationController = TabBarEnum.record.rootNavigationController
        let recordCoordinator = dependencies.makeRecordCoordinator(
            navigationController: recordNavigationController,
            finishDelegate: self
        )
        recordCoordinator.navigate(to: .writeRecordFlowIsRequired)
        self.recordCoordinator = recordCoordinator
        addChild(child: recordCoordinator)
        
        tabBarController.setViewControllers(
            [timerNavigationController, recordNavigationController],
            animated: false
        )
    }
    
    private func addNotificationObserver() {
        NotificationCenter.default.rx.notification(.localNotificationType)
            .withUnretained(self)
            .bind { owner, notification in
                guard let notificationType = notification.userInfo?[NotificationUserInfoKey.localNotificationType.rawValue] as? LocalNotificationType
                else { return }
                switch notificationType {
                case .fastStart:
                    owner.tabBarController.selectedIndex = 0
                    owner.timerCoordinator?.navigate(to: .fastStartNotification)
                case .fastEnd:
                    guard let yesterDay = Calendar.current.date(byAdding: .day, value: -1, to: Date()) else { return }
                    owner.timerCoordinator?.navigate(to: .fastEndNotification(startDate: yesterDay))
                    owner.tabBarController.selectedIndex = 1
                    owner.recordCoordinator?.navigate(to: .fastEndNotification(startDate: yesterDay))
                }
            }
            .disposed(by: disposeBag)
    }
}
