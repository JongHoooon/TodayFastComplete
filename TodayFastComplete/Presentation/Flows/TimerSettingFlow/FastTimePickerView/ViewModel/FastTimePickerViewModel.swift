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
        let fastTimes = Array(4...23)
    }
    
    private weak var coordinator: Coordinator?
    private let selectedFastTime: BehaviorRelay<Int>
    private let recommendSectionNeedDeselect: PublishRelay<Void>
    var currentFastTime: Int
    private let disposeBag = DisposeBag()
    
    init(
        coordinator: Coordinator,
        selectedFastTime: BehaviorRelay<Int>,
        recommendSectionNeedDeselect: PublishRelay<Void>,
        initialFastTime: Int
    ) {
        self.coordinator = coordinator
        self.selectedFastTime = selectedFastTime
        self.recommendSectionNeedDeselect = recommendSectionNeedDeselect
        self.currentFastTime = initialFastTime
    }
    
    deinit {
        Log.deinit()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.cancelButtonTapped
            .observe(on: MainScheduler.asyncInstance)
            .bind(onNext: { [weak self] _ in
                self?.coordinator?.navigate(to: .settingFastTimePickerViewIsComplete)
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
                self?.coordinator?.navigate(to: .settingFastTimePickerViewIsComplete)
                self?.selectedFastTime.accept(fastTime)
                self?.recommendSectionNeedDeselect.accept(Void())
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
