//
//  FastRecordViewModel.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/19/23.
//

import Foundation

import RxRelay
import RxSwift

final class FastRecordViewModel: ViewModel {
    
    struct Input { 
        let plusViewTapped: Observable<Void>
    }
    struct Output { 
        
    }
    
    private weak var coordinator: Coordinator?
    private let disposeBag: DisposeBag
    
    private let selectedDateRelay: BehaviorRelay<Date>
    private let fastRecordViewState: BehaviorRelay<RecordViewState>
    
    init(
        coordinator: Coordinator,
        selectedDateRelay: BehaviorRelay<Date>,
        fastRecordViewState: BehaviorRelay<RecordViewState>
    ) {
        self.coordinator = coordinator
        self.disposeBag = DisposeBag()
        self.selectedDateRelay = selectedDateRelay
        self.fastRecordViewState = fastRecordViewState
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        selectedDateRelay
            .subscribe(onNext: { _ in
                
            })
            .disposed(by: disposeBag)
        
        fastRecordViewState
            .subscribe(onNext: { state in
                switch state {
                case .cantRecord:
                    print("cant record")
                    
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        input.plusViewTapped
            .asDriver(onErrorJustReturn: Void())
            .drive(with: self, onNext: { owner, _ in
                owner.coordinator?.navigate(to: .writeFastRecord(startDate: owner.selectedDateRelay.value))
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
