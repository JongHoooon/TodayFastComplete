//
//  StartTimePickerViewModel.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/9/23.
//

import Foundation

import RxRelay
import RxSwift

final class StartTimePickerViewModel: ViewModel {
    struct Input {
        let cancelButtonTapped: Observable<Void>
        let complteButtonTapped: Observable<Date> 
    }
    
    // TODO: GA 기반 인기 시간 추천
    struct Output {
        
    }
    
    private weak var coordinator: Coordinator?
    private let selectedStartTime: BehaviorRelay<Date>
    let initialStartTime: Date
    
    init(
        coordinator: Coordinator,
        selectedStartTime: BehaviorRelay<Date>,
        initialStartTime: Date
    ) {
        self.coordinator = coordinator
        self.selectedStartTime = selectedStartTime
        self.initialStartTime = initialStartTime
    }
    
    deinit {
        Log.deinit()
    }
    
    func transform(
        input: Input,
        disposeBag: DisposeBag
    ) -> Output {
        let output = Output()
        
        input.cancelButtonTapped
            .observe(on: MainScheduler.asyncInstance)
            .bind(onNext: { [weak self] _ in
                self?.coordinator?.navigate(to: .settingStartTimePickerViewIsComplete)
            })
            .disposed(by: disposeBag)
        
        input.complteButtonTapped
            .observe(on: MainScheduler.asyncInstance)
            .bind(onNext: { [weak self] date in
                self?.coordinator?.navigate(to: .settingStartTimePickerViewIsComplete)
                self?.selectedStartTime.accept(date)
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
