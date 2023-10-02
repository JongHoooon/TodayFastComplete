//
//  CoordinatorFinishDelegate.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/2/23.
//

import Foundation

protocol CoordinatorFinishDelegate: AnyObject {
    func coordinatorDidFinish(child: Coordinator)
}

extension CoordinatorFinishDelegate where Self: Coordinator & BaseCoordinator {
    func coordinatorDidFinish(child: Coordinator) {
        self.removeChild(child: child)
    }
}
