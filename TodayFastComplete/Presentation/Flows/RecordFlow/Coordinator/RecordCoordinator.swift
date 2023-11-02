//
//  RecordCoordinator.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/17/23.
//

import UIKit

import RxSwift

protocol RecordCoordinatorDependencies: AnyObject { 
    func makeRecordMainViewController(coordinator: Coordinator, pageViewController: UIPageViewController) -> UIViewController
    func makeWriteFastRecord(coordinator: Coordinator, startDate: Date) -> UIViewController
}

final class RecordCoordinator: BaseCoordinator,
                               CoordinatorFinishDelegate,
                               SimpleMessageAlertPresentable {

    private let rootViewController: UINavigationController
    private var writeFastRecordNavigationController: UINavigationController?
    private var mainPageViewController: UIPageViewController?
    private let dependencies: RecordCoordinatorDependencies
    private let disposeBag: DisposeBag
    
    init(
        rootViewController: UINavigationController,
        dependencies: RecordCoordinatorDependencies,
        finishDelegate: CoordinatorFinishDelegate
    ) {
        self.rootViewController = rootViewController
        self.dependencies = dependencies
        self.disposeBag = DisposeBag()
    }
    
    override func navigate(to step: Step) {
        switch step {
        case .writeRecordFlowIsRequired:
            showRecordMain()
        case let .writeFastRecord(startDate):
            presentWriteFastRecord(startDate: startDate)
        case let .fastEndNotification(startDate):
            fastEndNotification(startDate: startDate)
        case .writeFastRecordIsComplete:
            dismissPresentedView()
        case let .writeRecordValidateAlert(title, message):
            guard let nav = writeFastRecordNavigationController else { return }
            presentSimpleAlert(
                navigationController: nav,
                title: title,
                message: message
            )
            .bind { _ in }
            .disposed(by: disposeBag)
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
        writeFastRecordNavigationController = nav
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
