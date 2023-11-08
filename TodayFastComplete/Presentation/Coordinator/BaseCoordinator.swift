//
//  BaseCoordinator.swift
//  TodayFastComplete
//
//  Created by JongHoon on 11/3/23.
//

import UIKit

class BaseCoordinator: Coordinator {
    
    private(set) var childCoordinators: [Coordinator] = []
    
    var finishDelegate: CoordinatorFinishDelegate?
    
    func addChild(child: Coordinator) {
        childCoordinators.append(child)
    }

    func removeChild(child: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== child }
    }
    
    func removeAllChild() {
        childCoordinators.removeAll()
    }

    func navigate(to step: Step) { }
    
    func finish() {
        removeAllChild()
        finishDelegate?.coordinatorDidFinish(child: self)
    }
}
