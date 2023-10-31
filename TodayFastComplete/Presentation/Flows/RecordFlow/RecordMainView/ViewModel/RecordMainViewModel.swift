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
        let toggleButtonTapped: Observable<Void>
        let beforeButtonTapped: Observable<Void>
        let afterButtonTapped: Observable<Void>
    }
    
    struct Output {
        let currentPage = BehaviorRelay(value: 0)
        let calendarScope = BehaviorRelay(value: 1)
        let dateInfoLabelText = BehaviorRelay(value: Date().toString(format: .yearMonthDayWeekDayFormat))
    }
    
    private let coordinator: Coordinator
    private let calendarformatter = DateFormatter.yearMonthDayFormat
    private let disposeBag: DisposeBag
    
    private let selectedDateRelay: BehaviorRelay<Date>
    
    init(
        coordinator: Coordinator,
        selectedDateRelay: BehaviorRelay<Date>
    ) {
        self.coordinator = coordinator
        self.disposeBag = DisposeBag()
        self.selectedDateRelay = selectedDateRelay
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
        
        input.toggleButtonTapped
            .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.asyncInstance)
            .map { _ in output.calendarScope.value == 1 ? 0 : 1 }
            .bind { output.calendarScope.accept($0) }
            .disposed(by: disposeBag)
        
        let calendarDidSelectShared = input.calendarDidSelect.share()
        
        calendarDidSelectShared
            .bind(with: self, onNext: { owner, date in
                Log.debug(date.toString(format: owner.calendarformatter))
                Log.debug(Date().toString(format: .yearMonthDayFormat))
                owner.selectedDateRelay.accept(date)
            })
            .disposed(by: disposeBag)
        
        calendarDidSelectShared
            .map { $0.toString(format: .yearMonthDayWeekDayFormat) }
            .bind(onNext: { output.dateInfoLabelText.accept($0) })
            .disposed(by: disposeBag)
            
        return output
    }
}
