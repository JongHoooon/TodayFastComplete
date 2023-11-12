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
    
    init(
        coordinator: Coordinator,
        selectedDateRelay: BehaviorRelay<Date>,
        weightRecordViewState: BehaviorRelay<RecordViewState>
    ) {
        self.disposeBag = DisposeBag()
        self.selectedDateRelay = selectedDateRelay
        self.weightRecordViewState = weightRecordViewState
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        weightRecordViewState
            .map { state in
                return switch state {
                case .cantRecord:
                    (true, true, false)
                case .recordExist:
                    (true, false, true)
                case .noRecord:
                    (false, true, true)
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
