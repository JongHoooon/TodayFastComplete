//
//  RecordDIContainer.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/17/23.
//

import UIKit

import RxRelay

final class RecordDIContainer: RecordCoordinatorDependencies {
    
    private let selectedDateRelay = BehaviorRelay(value: Date().toCalendarDate)
    private let fastRecordViewState = BehaviorRelay<RecordViewState>(value: .noRecord)
    private let weightRecordViewState = BehaviorRelay<RecordViewState>(value: .noRecord)
    private let editButtonTapped = PublishRelay<Void>()
    private let deleteButtonTapped = BehaviorRelay<RecordEnum>(value: .fast)
    private let fastRecordUpdateRelay = PublishRelay<FastRecord>()
    private let weightRecordUpdateRelay = PublishRelay<WeightRecord>()
    
    // MARK: - Use Case
    func makeRecordUseCase() -> RecordUseCase {
        return RecordUseCaseImp(
            fastRecordRepository: makeFastRecordRepository(),
            weightRecordRepository: makeWeightRecordRepository()
        )
    }
    
    // MARK: - Repository
    func makeFastRecordRepository() -> FastRecordRepository {
        do {
            let repository = try DefaultFastRecordRepository()
            return repository
        } catch {
            Log.error(error)
            fatalError("init realm repository failed")

        }
    }
    
    func makeWeightRecordRepository() -> WeightRecordRepository {
        do {
            let repository = try DefaultWeightRecordRepository()
            return repository
        } catch {
            Log.error(error)
            fatalError("init realm repository failed")
        }
    }
    
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
    
    private func makeRecordMainViewModel(
        coordinator: Coordinator,
        selectedDateRelay: BehaviorRelay<Date>
    ) -> RecordMainViewModel {
        return RecordMainViewModel(
            coordinator: coordinator,
            recordUseCase: makeRecordUseCase(),
            selectedDateRelay: selectedDateRelay,
            fastRecordViewState: fastRecordViewState,
            weightRecordViewState: weightRecordViewState,
            editButtonTapped: editButtonTapped,
            deleteButtonTapped: deleteButtonTapped,
            fastRecordUpdateRelay: fastRecordUpdateRelay,
            weightRecordUpdateRelay: weightRecordUpdateRelay
        )
    }
    
    // MARK: - Fast Record
    private func makeFastRecordViewController(
        coordinator: Coordinator,
        selectedDateRelay: BehaviorRelay<Date>
    ) -> UIViewController {
        return FastRecordViewController(viewModel: makeFastRecordViewModel(
            coordinator: coordinator,
            selectedDateRelay: selectedDateRelay
        ))
    }
    
    private func makeFastRecordViewModel(
        coordinator: Coordinator,
        selectedDateRelay: BehaviorRelay<Date>
    ) -> FastRecordViewModel {
        return FastRecordViewModel(
            coordinator: coordinator,
            selectedDateRelay: selectedDateRelay,
            fastRecordViewState: fastRecordViewState, 
            editButtonTapped: editButtonTapped,
            deleteButtonTapped: deleteButtonTapped
        )
    }
    
    // MARK: - Weight Record
    private func makeWeightRecordViewController(
        coordinator: Coordinator,
        selectedDateRelay: BehaviorRelay<Date>
    ) -> UIViewController {
        return WeightRecordViewController(viewModel: makeWeightRecordViewModel(
            coordinator: coordinator,
            selectedDateRelay: selectedDateRelay
        ))
    }
    
    private func makeWeightRecordViewModel(
        coordinator: Coordinator,
        selectedDateRelay: BehaviorRelay<Date>
    ) -> WeightRecordViewModel {
        return WeightRecordViewModel(
            coordinator: coordinator,
            selectedDateRelay: selectedDateRelay,
            weightRecordViewState: weightRecordViewState,
            editButtonTapped: editButtonTapped,
            deleteButtonTapped: deleteButtonTapped
        )
    }
    
    // MARK: - Write Fast Record
    func makeWriteFastRecord(
        coordinator: Coordinator,
        startDate: Date,
        fastRecord: FastRecord?,
        weightRecord: WeightRecord?
    ) -> UIViewController {
        return WriteFastRecordViewController(viewModel: makeWriteFastRecordViewModel(
            coordinator: coordinator,
            startDate: startDate,
            fastRecord: fastRecord,
            weightRecord: weightRecord
        ))
    }
    
    private func makeWriteFastRecordViewModel(
        coordinator: Coordinator,
        startDate: Date,
        fastRecord: FastRecord?,
        weightRecord: WeightRecord?
    ) -> WriteFastRecordViewModel {
        return WriteFastRecordViewModel(
            coordinator: coordinator,
            useCase: makeRecordUseCase(),
            startDate: startDate,
            fastRecordUpdateRelay: fastRecordUpdateRelay,
            weightRecordUpdateRelay: weightRecordUpdateRelay,
            fastRecord: fastRecord,
            weightRecord: weightRecord
        )
    }
}
