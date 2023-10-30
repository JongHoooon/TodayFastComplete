//
//  RecordCoordinator.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/17/23.
//

import UIKit

import RxRelay

protocol RecordCoordinatorDependencies: AnyObject { 
    func makeRecordMainViewController(coordinator: Coordinator, pageViewController: UIPageViewController) -> UIViewController
    func makeWriteFastRecord(coordinator: Coordinator, startDate: Date) -> UIViewController
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
        case let .writeFastRecord(startDate):
            presentWriteFastRecord(startDate: startDate)
        case let .fastEndNotification(startDate):
            fastEndNotification(startDate: startDate)
        case .writeFastRecordIsComplete:
            dismissPresentedView()
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
    
    func presentWriteFastRecord(startDate: Date) {
        let vc = dependencies.makeWriteFastRecord(coordinator: self, startDate: startDate)
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        rootViewController.present(nav, animated: true)
    }
    
    func dismissPresentedView() {
        rootViewController.presentedViewController?.dismiss(animated: true)
    }
    
    func fastEndNotification(startDate: Date) {
        presentWriteFastRecord(startDate: startDate)
    }
}
