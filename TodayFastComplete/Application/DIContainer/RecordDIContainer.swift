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
            pageViewChildViewControllers: [
                makeFastRecordViewController(coordinator: coordinator),
                makeWeightRecordViewController()
            ]
        )
    }
    
    private func makeRecordMainViewModel(coordinator: Coordinator) -> RecordMainViewModel {
        return RecordMainViewModel(coordinator: coordinator)
    }
    
    // MARK: - Fast Record
    private func makeFastRecordViewController(coordinator: Coordinator) -> UIViewController {
        return FastRecordViewController(viewModel: makeFastRecordViewModel(coordinator: coordinator))
    }
    
    private func makeFastRecordViewModel(coordinator: Coordinator) -> FastRecordViewModel {
        return FastRecordViewModel(coordinator: coordinator)
    }
    
    // MARK: - Weight Record
    private func makeWeightRecordViewController() -> UIViewController {
        return WeightRecordViewController()
    }
    
    // MARK: - Write Fast Record
    func makeWriteFastRecord(coordinator: Coordinator) -> UIViewController {
        return WriteFastRecordViewController(viewModel: makeWriteFastRecordViewModel(coordinator: coordinator))
    }
    
    private func makeWriteFastRecordViewModel(coordinator: Coordinator) -> WriteFastRecordViewModel {
        return WriteFastRecordViewModel(coordinator: coordinator)
    }
}
