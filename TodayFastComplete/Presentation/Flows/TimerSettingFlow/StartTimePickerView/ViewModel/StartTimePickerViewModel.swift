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
    
    struct Output {
        
    }
    
    private var coordinator: Coordinator
    private let selectedStartTime: PublishRelay<Date>
    
    init(
        coordinator: Coordinator,
        selectedStartTime: PublishRelay<Date>
    ) {
        self.coordinator = coordinator
        self.selectedStartTime = selectedStartTime
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
                self?.coordinator.navigate(to: .settingStartTimePickerViewIsComplete)
            })
            .disposed(by: disposeBag)
        
        input.complteButtonTapped
            .observe(on: MainScheduler.asyncInstance)
            .bind(onNext: { [weak self] date in
                self?.coordinator.navigate(to: .settingStartTimePickerViewIsComplete)
                self?.selectedStartTime.accept(date)
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
