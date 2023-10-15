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
        let complteButtonTappedWithSelectedTime: Observable<DateComponents>
    }
    
    // TODO: GA 기반 인기 시간 추천
    struct Output {
        
    }
    
    private weak var coordinator: Coordinator?
    private let selectedStartTime: BehaviorRelay<DateComponents>
    let initialStartTime: DateComponents
    private let disposeBag = DisposeBag()
    
    init(
        coordinator: Coordinator,
        selectedStartTime: BehaviorRelay<DateComponents>,
        initialStartTime: DateComponents
    ) {
        self.coordinator = coordinator
        self.selectedStartTime = selectedStartTime
        self.initialStartTime = initialStartTime
    }
    
    deinit {
        Log.deinit()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.cancelButtonTapped
            .observe(on: MainScheduler.asyncInstance)
            .bind(onNext: { [weak self] _ in
                self?.coordinator?.navigate(to: .settingStartTimePickerViewIsComplete)
            })
            .disposed(by: disposeBag)
        
        input.complteButtonTappedWithSelectedTime
            .observe(on: MainScheduler.asyncInstance)
            .bind(onNext: { [weak self] date in
                self?.coordinator?.navigate(to: .settingStartTimePickerViewIsComplete)
                self?.selectedStartTime.accept(date)
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
