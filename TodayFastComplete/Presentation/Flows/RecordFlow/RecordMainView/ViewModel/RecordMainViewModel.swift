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
        let swipeUpGesture: Observable<Void>
        let swipeDownGesture: Observable<Void>
        let calendarDidSelect: Observable<Date>
    }
    
    struct Output {
        let currentPage = BehaviorRelay(value: 0)
        let calendarScope = BehaviorRelay(value: 1)
    }
    
    private let coordinator: Coordinator
    private let calendarformatter = DateFormatter.yearMonthDayFormat
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
        
        input.swipeUpGesture
            .map { 1 } // FSCalendarScope enum week raw value
            .bind { output.calendarScope.accept($0) }
            .disposed(by: disposeBag)
        
        input.swipeDownGesture
            .map { 0 } // FSCalendarScope enum month raw value
            .bind { output.calendarScope.accept($0) }
            .disposed(by: disposeBag)
        
        input.calendarDidSelect
            .subscribe(with: self, onNext: { owner, date in
                Log.debug(date.toString(format: owner.calendarformatter))
                Log.debug(Date().toString(format: .yearMonthDayFormat))
            })
            .disposed(by: disposeBag)
            
        return output
    }
}
