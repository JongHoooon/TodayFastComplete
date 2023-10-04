//
//  Coordinator.swift
//  TodayFastComplete
//
//  Created by JongHoon on 9/30/23.
//

import UIKit

protocol Coordinator: AnyObject {
    func navigate(to step: Step)
    func finish()
}

extension Coordinator where Self: BaseCoordinator {
    func finish() {
        removeAllChild()
        finishDelegate?.coordinatorDidFinish(child: self)
    }
}
