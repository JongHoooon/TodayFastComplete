//
//  FastTimePickerViewModel.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/9/23.
//

import Foundation

import RxRelay
import RxSwift

final class FastTimePickerViewModel: ViewModel {
    struct Input {
        let cancelButtonTapped: Observable<Void>
        let complteButtonTapped: Observable<Void>
        let itemSelected: Observable<Int>
    }
    
    struct Output {
        let fastTimes = Array(1...23)
    }
    
    private var coordinator: Coordinator
    private var selectedFastTime: BehaviorRelay<String>
    private var currentFastTime: Int = 0
    
    init(
        coordinator: Coordinator,
        selectedFastTime: BehaviorRelay<String>
    ) {
        self.coordinator = coordinator
        self.selectedFastTime = selectedFastTime
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
                self?.coordinator.navigate(to: .settingFastTimePickerViewIsComplete)
            })
            .disposed(by: disposeBag)
        
        input.itemSelected
            .map { output.fastTimes[$0] }
            .bind(
                with: self,
                onNext: { owner, fastTime in
                    owner.currentFastTime = fastTime
            })
            .disposed(by: disposeBag)
        
        input.complteButtonTapped
            .observe(on: MainScheduler.asyncInstance)
            .compactMap { [weak self] _ in self?.currentFastTime }
            .bind(onNext: { [weak self] fastTime in
                self?.coordinator.navigate(to: .settingFastTimePickerViewIsComplete)
                self?.selectedFastTime.accept(String(
                    localized: "HOURS",
                    defaultValue: "\(fastTime) 시간"
                ))
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
