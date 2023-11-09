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
        let calendarCurrentPageDidChange: Observable<Date>
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
    private let fastRecordViewState: BehaviorRelay<RecordViewState>
    private let weightRecordViewState: BehaviorRelay<RecordViewState>
    
    init(
        coordinator: Coordinator,
        selectedDateRelay: BehaviorRelay<Date>,
        fastRecordViewState: BehaviorRelay<RecordViewState>,
        weightRecordViewState: BehaviorRelay<RecordViewState>
    ) {
        self.coordinator = coordinator
        self.disposeBag = DisposeBag()
        self.selectedDateRelay = selectedDateRelay
        self.fastRecordViewState = fastRecordViewState
        self.weightRecordViewState = weightRecordViewState
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.selectedSegmentIndex
            .bind { output.currentPage.accept($0) }
            .disposed(by: disposeBag)
        
        /*
         FSCalendarScope enum month raw value:  0
         FSCalendarScope enum week raw value:   1
         */
        input.swipeUpGesture
            .map { 1 }
            .bind { output.calendarScope.accept($0) }
            .disposed(by: disposeBag)
        
        input.swipeDownGesture
            .map { 0 }
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
                owner.selectedDateRelay.accept(date)
                if Date().toCalendarDate < date {
                    owner.fastRecordViewState.accept(.cantRecord)
                    owner.weightRecordViewState.accept(.cantRecord)
                } else {
                    owner.fastRecordViewState.accept(.dataExist)
                    owner.weightRecordViewState.accept(.dataExist)
                }
            })
            .disposed(by: disposeBag)
        
        calendarDidSelectShared
            .map { $0.toString(format: .yearMonthDayWeekDayFormat) }
            .bind(onNext: { output.dateInfoLabelText.accept($0) })
            .disposed(by: disposeBag)
        
        input.calendarCurrentPageDidChange
            .map(\.month)
            .distinctUntilChanged()
            .bind {
                print($0)
//                print($0.month)
            }
            .disposed(by: disposeBag)
            
        return output
    }
}
