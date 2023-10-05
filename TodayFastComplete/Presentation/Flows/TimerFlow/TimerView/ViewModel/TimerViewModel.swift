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
        let viewDidLoad: Observable<Void>
        let viewWillAppear: Observable<Void>
    }
    
    struct Output {
        let fastTitle = PublishRelay<String>()
        let fastInfoTitle = PublishRelay<String>()
        let messageText = PublishRelay<String>()
        let progressTime = PublishRelay<String>()
        let remainTime = PublishRelay<String>()
        let todayStartTime = PublishRelay<String>()
        let todayEndTime = PublishRelay<String>()
        let fastControlButtonTitle = PublishRelay<String>()
    }
    
    func transform(
        input: Input,
        disposeBag: DisposeBag
    ) -> Output {
        let output = Output()
        
        return output
    }
}
