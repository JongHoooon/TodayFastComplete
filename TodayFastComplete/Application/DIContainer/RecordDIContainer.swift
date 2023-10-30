//
//  RecordDIContainer.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/17/23.
//

import UIKit

import RxRelay

final class RecordDIContainer: RecordCoordinatorDependencies {
    
    private let selectedDateRelay = BehaviorRelay(value: Date())
    
    // MARK: - Record View
    func makeRecordMainViewController(
        coordinator: Coordinator,
        pageViewController: UIPageViewController
    ) -> UIViewController {
        return RecordMainViewController(
            viewModel: makeRecordMainViewModel(coordinator: coordinator, selectedDateRelay: selectedDateRelay),
            pageViewController: pageViewController,
            pageViewChildViewControllers: [
                makeFastRecordViewController(coordinator: coordinator, selectedDateRelay: selectedDateRelay),
                makeWeightRecordViewController(coordinator: coordinator, selectedDateRelay: selectedDateRelay)
            ]
        )
    }
    
    private func makeRecordMainViewModel(coordinator: Coordinator, selectedDateRelay: BehaviorRelay<Date>) -> RecordMainViewModel {
        return RecordMainViewModel(coordinator: coordinator, selectedDateRelay: selectedDateRelay)
    }
    
    // MARK: - Fast Record
    private func makeFastRecordViewController(coordinator: Coordinator, selectedDateRelay: BehaviorRelay<Date>) -> UIViewController {
        return FastRecordViewController(viewModel: makeFastRecordViewModel(coordinator: coordinator, selectedDateRelay: selectedDateRelay))
    }
    
    private func makeFastRecordViewModel(coordinator: Coordinator, selectedDateRelay: BehaviorRelay<Date>) -> FastRecordViewModel {
        return FastRecordViewModel(coordinator: coordinator, selectedDateRelay: selectedDateRelay)
    }
    
    // MARK: - Weight Record
    private func makeWeightRecordViewController(coordinator: Coordinator, selectedDateRelay: BehaviorRelay<Date>) -> UIViewController {
        return WeightRecordViewController(viewModel: makeWeightRecordViewModel(coordinator: coordinator, selectedDateRelay: selectedDateRelay))
    }
    
    private func makeWeightRecordViewModel(coordinator: Coordinator, selectedDateRelay: BehaviorRelay<Date>) -> WeightRecordViewModel {
        return WeightRecordViewModel(coordinator: coordinator, selectedDateRelay: selectedDateRelay)
    }
    
    // MARK: - Write Fast Record
    func makeWriteFastRecord(coordinator: Coordinator, startDate: Date) -> UIViewController {
        return WriteFastRecordViewController(viewModel: makeWriteFastRecordViewModel(coordinator: coordinator, startDate: startDate))
    }
    
    private func makeWriteFastRecordViewModel(coordinator: Coordinator, startDate: Date) -> WriteFastRecordViewModel {
        return WriteFastRecordViewModel(coordinator: coordinator, startDate: startDate)
    }
}
