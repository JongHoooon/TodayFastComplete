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
    
    struct Input { }
    
    struct Output { 
        let plusViewIsHidden = BehaviorRelay(value: true)
        let recordViewIsHidden = BehaviorRelay(value: true)
        let cantRecordLabelIsHidden = BehaviorRelay(value: true)
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
        
        selectedDateRelay
            .subscribe(onNext: { _ in
                
            })
            .disposed(by: disposeBag)
        
        weightRecordViewState
            .map { state in
                return switch state {
                case .cantRecord:
                    (true, true, false)
                case .dataExist:
                    (true, false, true)
                case .noData:
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
