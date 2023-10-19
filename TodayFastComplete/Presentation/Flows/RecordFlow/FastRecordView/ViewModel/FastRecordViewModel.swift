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
        let writeFastRecordButtonTapped: Observable<Void>
    }
    struct Output { 
        
    }
    
    private weak var coordinator: Coordinator?
    private let disposeBag: DisposeBag
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        self.disposeBag = DisposeBag()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.writeFastRecordButtonTapped
            .asDriver(onErrorJustReturn: Void())
            .drive(with: self, onNext: { owner, _ in
                owner.coordinator?.navigate(to: .writeFastRecord)
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
