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
        let plusViewIsHidden = BehaviorRelay(value: true)
        let recordViewIsHidden = BehaviorRelay(value: true)
        let cantRecordLabelIsHidden = BehaviorRelay(value: true)
        let fastStartTime = BehaviorRelay(value: Date())
        let fastEndTime = BehaviorRelay(value: Date())
        let fastTimeSecond = BehaviorRelay(value: 0)
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
        
        let fastRecordViewStateShared = fastRecordViewState.share()
        
        fastRecordViewStateShared
            .bind {
                guard case let RecordViewState.recordExist(record) = $0,
                      let record = record as? FastRecord
                else {
//                    assertionFailure("fail casting record")
                    return
                }
                output.fastStartTime.accept(record.startDate)
                output.fastEndTime.accept(record.endDate)
            }
            .disposed(by: disposeBag)
 
        fastRecordViewStateShared
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
        
        input.plusViewTapped
            .asDriver(onErrorJustReturn: Void())
            .drive(with: self, onNext: { owner, _ in
                owner.coordinator?.navigate(to: .writeFastRecord(startDate: owner.selectedDateRelay.value))
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
