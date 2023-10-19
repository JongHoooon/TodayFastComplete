//
//  RecordDIContainer.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/17/23.
//

import UIKit

final class RecordDIContainer: RecordCoordinatorDependencies {
    
    // MARK: - Record View
    func makeRecordMainViewController(
        coordinator: Coordinator,
        pageViewController: UIPageViewController
    ) -> UIViewController {
        return RecordMainViewController(
            viewModel: makeRecordMainViewModel(coordinator: coordinator),
            pageViewController: pageViewController,
            pageViewChildViewControllers: [makeFastRecordViewController(), makeWeightRecordViewController()]
        )
    }
    
    private func makeRecordMainViewModel(coordinator: Coordinator) -> RecordMainViewModel {
        return RecordMainViewModel(coordinator: coordinator)
    }
    
    // MARK: - Fast Record
    private func makeFastRecordViewController() -> UIViewController {
        return FastRecordViewController()
    }
    
    // MARK: - Weight Record
    private func makeWeightRecordViewController() -> UIViewController {
        return WeightRecordViewController()
    }
}
