//
//  SelectFastModeViewModel.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/5/23.
//

import Foundation

import RxRelay
import RxSwift

final class SelectFastModeViewModel: ViewModel {
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let viewDidDismissed: Observable<Void>
        let modeSelected: Observable<FastMode>
        let nextButtonTapped: Observable<Void>
        let dismissButtonTapped: Observable<Void>
    }
    
    struct Output {
        let fastModeItems = BehaviorRelay<[FastMode]>(value: FastMode.allCases)
        let infoLabelText = BehaviorRelay<String>(value: FastMode.routine.explanation)
    }
    
    private weak var coordinator: Coordinator?
    private let disposeBag = DisposeBag()
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    deinit {
        Log.deinit()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.viewDidDismissed
            .bind(
                with: self,
                onNext: { owner, _ in
                    owner.coordinator?.finish()
            })
            .disposed(by: disposeBag)
        
        input.modeSelected
            .map { $0.explanation }
            .bind(onNext: { explanation in
                output.infoLabelText.accept(explanation)
            })
            .disposed(by: disposeBag)
        
        input.dismissButtonTapped
            .bind(
                with: self,
                onNext: { owner, _ in
                    owner.coordinator?.navigate(to: .settingTimerFlowIsComplete)
            })
            .disposed(by: disposeBag)
        return output
    }
}
