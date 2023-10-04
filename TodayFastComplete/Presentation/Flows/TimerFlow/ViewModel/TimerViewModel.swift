//
//  TimerViewModel.swift
//  TodayFastComplete
//
//  Created by JongHoon on 9/30/23.
//

import Foundation

import RxRelay
import RxSwift

final class TimerViewModel: ViewModel {
    struct Input {
        
    }
    
    struct Output {
//        var startTime: BehaviorRelay<Date> = BehaviorRelay(value: Date())
//        var endTime: Observable<Date>
//        var progressDegree: Observable<CGFloat>
    }
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        return Output()
    }
}
