//
//  RecordCoordinator.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/17/23.
//

import UIKit

protocol RecordCoordinatorDependencies: AnyObject { 
    func makeRecordMainViewController(coordinator: Coordinator) -> UIViewController
}

final class RecordCoordinator: BaseCoordinator,
                               CoordinatorFinishDelegate {

    private let rootViewController: UINavigationController
    private let dependencies: RecordCoordinatorDependencies
    
    init(
        rootViewController: UINavigationController,
        dependencies: RecordCoordinatorDependencies,
        finishDelegate: CoordinatorFinishDelegate
    ) {
        self.rootViewController = rootViewController
        self.dependencies = dependencies
    }
    
    override func navigate(to step: Step) {
        switch step {
        case .recordFlowIsRequired:
            showRecordMain()
        default:
            assertionFailure("not configured step")
        }
    }
}

private extension RecordCoordinator {
    func showRecordMain() {
        let vc = dependencies.makeRecordMainViewController(coordinator: self)
        rootViewController.viewControllers = [vc]
    }
}
