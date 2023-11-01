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
    
    struct Output { }
    
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
        
        selectedDateRelay
            .debug()
            .subscribe(onNext: { _ in
                
            })
            .disposed(by: disposeBag)
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        return output
    }
    
}
