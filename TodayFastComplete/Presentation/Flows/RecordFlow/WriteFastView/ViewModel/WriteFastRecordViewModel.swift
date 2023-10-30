//
//  WriteFastRecordViewModel.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/19/23.
//

import Foundation

import RxRelay
import RxSwift

final class WriteFastRecordViewModel: ViewModel {
    
    struct Input { 
        let fastStartTitleViewTapped: Observable<Void>
        let fastEndTitleViewTapped: Observable<Void>
        let dismissButtonTapped: Observable<Void>
        let minusWeightButtonTapped: Observable<Void>
        let plusWeightButtonTapped: Observable<Void>
    }
    
    struct Output { 
        let startDatePickerIsShow = BehaviorRelay(value: false)
        let endDatePickerIsShow = BehaviorRelay(value: false)
    }
    
    private let coordinator: Coordinator
    
    private let disposeBag: DisposeBag
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        self.disposeBag = DisposeBag()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.dismissButtonTapped
            .bind(with: self, onNext: { owner, _ in
                owner.coordinator.navigate(to: .writeFastRecordIsComplete)
            })
            .disposed(by: disposeBag)
        
        input.fastStartTitleViewTapped
            .withLatestFrom(output.startDatePickerIsShow)
            .bind(onNext: { output.startDatePickerIsShow.accept(!$0) })
            .disposed(by: disposeBag)
        
        input.fastEndTitleViewTapped
            .withLatestFrom(output.endDatePickerIsShow)
            .bind(onNext: { output.endDatePickerIsShow.accept(!$0) })
            .disposed(by: disposeBag)
        
        input.minusWeightButtonTapped
            .bind(onNext: {
                
            })
            .disposed(by: disposeBag)
        
        input.plusWeightButtonTapped
            .bind(onNext: {
                
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
