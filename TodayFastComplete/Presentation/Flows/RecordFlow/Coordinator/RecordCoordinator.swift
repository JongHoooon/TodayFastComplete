//
//  RecordCoordinator.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/17/23.
//

import UIKit

protocol RecordCoordinatorDependencies: AnyObject { 
    func makeRecordMainViewController(coordinator: Coordinator, pageViewController: UIPageViewController) -> UIViewController
    func makeWriteFastRecord(coordinator: Coordinator) -> UIViewController
}

final class RecordCoordinator: BaseCoordinator,
                               CoordinatorFinishDelegate {

    private let rootViewController: UINavigationController
    private var mainPageViewController: UIPageViewController?
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
        case .writeFastRecord:
            presentWriteFastRecord()
        default:
            assertionFailure("not configured step")
        }
    }
}

private extension RecordCoordinator {
    func showRecordMain() {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        mainPageViewController = pageViewController
        
        let vc = dependencies.makeRecordMainViewController(
            coordinator: self,
            pageViewController: pageViewController
        )
        rootViewController.viewControllers = [vc]
    }
    
    func presentWriteFastRecord() {
        let vc = dependencies.makeWriteFastRecord(coordinator: self)
        rootViewController.present(vc, animated: true)
    }
}
