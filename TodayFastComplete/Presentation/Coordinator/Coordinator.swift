//
//  Coordinator.swift
//  TodayFastComplete
//
//  Created by JongHoon on 9/30/23.
//

import UIKit

protocol Coordinator: AnyObject {
    var finishDelegate: CoordinatorFinishDelegate? { get set }
    func start()
}
