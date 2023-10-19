//
//  RecordMainViewModel.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/17/23.
//

import Foundation

import RxRelay
import RxSwift

final class RecordMainViewModel: ViewModel {
    struct Input {
        let selectedSegmentIndex: Observable<Int>
    }
    
    struct Output {
        let currentPage = BehaviorRelay(value: 0)
    }
    
    private let coordinator: Coordinator
    private let disposeBag: DisposeBag
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        self.disposeBag = DisposeBag()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.selectedSegmentIndex
            .bind { output.currentPage.accept($0) }
            .disposed(by: disposeBag)
            
        return output
    }
}
