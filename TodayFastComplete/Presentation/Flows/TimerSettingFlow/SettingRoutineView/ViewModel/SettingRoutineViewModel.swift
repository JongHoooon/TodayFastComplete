//
//  SettingRoutineViewModel.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/5/23.
//

import Foundation

import RxCocoa
import RxSwift

final class SettingRoutineViewModel: ViewModel {
    
    struct Input {
        let viewDidDismissed: ControlEvent<Void>
        let dismissButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        
    }
    
    private weak var coordinator: Coordinator?
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    deinit {
        Log.deinit()
    }
    
    func transform(
        input: Input,
        disposeBag: DisposeBag
    ) -> Output {
        let output = Output()
        
        input.viewDidDismissed
            .bind(
                with: self,
                onNext: { owner, _ in
                    owner.coordinator?.finish()
            })
            .disposed(by: disposeBag)
        
        input.dismissButtonTapped
            .bind(
                with: self,
                onNext: { owner, _ in
                    owner.coordinator?.navigate(to: .settingTimerFlowDismissButtonTapped)
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
