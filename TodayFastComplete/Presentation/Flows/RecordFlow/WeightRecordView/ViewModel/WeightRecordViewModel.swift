//
//  WeightRecordViewModel.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/31/23.
//

import Foundation

import RxRelay
import RxSwift

final class WeightRecordViewModel: ViewModel {
    
    struct Input { 
        let plusViewTapped: Observable<Void>
        let editButtonTapped: Observable<Void>
        let deleteButtonTapped: Observable<Void>
    }
    
    struct Output { 
        let plusViewIsHidden = BehaviorRelay(value: true)
        let recordViewIsHidden = BehaviorRelay(value: true)
        let cantRecordLabelIsHidden = BehaviorRelay(value: true)
        let weight = BehaviorRelay(value: 0.0)
    }
    
    private weak var coordinator: Coordinator?
    private let disposeBag: DisposeBag
    private let selectedDateRelay: BehaviorRelay<Date>
    private let weightRecordViewState: BehaviorRelay<RecordViewState>
    private let editButtonTapped: PublishRelay<Void>
    private let deleteButtonTapped: BehaviorRelay<RecordEnum>
    
    init(
        coordinator: Coordinator,
        selectedDateRelay: BehaviorRelay<Date>,
        weightRecordViewState: BehaviorRelay<RecordViewState>,
        editButtonTapped: PublishRelay<Void>,
        deleteButtonTapped: BehaviorRelay<RecordEnum>
    ) {
        self.coordinator = coordinator
        self.selectedDateRelay = selectedDateRelay
        self.weightRecordViewState = weightRecordViewState
        self.editButtonTapped = editButtonTapped
        self.deleteButtonTapped = deleteButtonTapped
        self.disposeBag = DisposeBag()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.plusViewTapped
            .throttle(
                .milliseconds(500),
                latest: false,
                scheduler: MainScheduler.asyncInstance
            )
            .map { [unowned self] in Step.writeFastRecord(startDate: selectedDateRelay.value) }
            .bind { [unowned self] in coordinator?.navigate(to: $0) }
            .disposed(by: disposeBag)
        
        input.editButtonTapped
            .bind(to: editButtonTapped)
            .disposed(by: disposeBag)
        
        input.deleteButtonTapped
            .map { RecordEnum.weight }
            .bind(to: deleteButtonTapped)
            .disposed(by: disposeBag)
        
        let weightRecordViewStateShared = weightRecordViewState.share(replay: 1)
        
        weightRecordViewStateShared
            .bind(onNext: { state in
                guard case let RecordViewState.recordExist(record) = state,
                      let record = record as? WeightRecord
                else { return }
                output.weight.accept(record.weight)
            })
            .disposed(by: disposeBag)
        
        weightRecordViewStateShared
            .map { state in
                return switch state {
                case .cantRecord:       (true, true, false)
                case .recordExist:      (true, false, true)
                case .noRecord:         (false, true, true)
                }
            }
            .bind {
                output.plusViewIsHidden.accept($0.0)
                output.recordViewIsHidden.accept($0.1)
                output.cantRecordLabelIsHidden.accept($0.2)
            }
            .disposed(by: disposeBag)
        
        return output
    }
}
