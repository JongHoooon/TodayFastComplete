//
//  RecordDIContainer.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/17/23.
//

import UIKit

final class RecordDIContainer: RecordCoordinatorDependencies {
    
    // MARK: - Record View
    func makeRecordMainViewController(coordinator: Coordinator) -> UIViewController {
        return RecordMainViewController(viewModel: makeRecordMainViewModel(coordinator: coordinator))
    }
    
    private func makeRecordMainViewModel(coordinator: Coordinator) -> RecordMainViewModel {
        return RecordMainViewModel(coordinator: coordinator)
    }
}
