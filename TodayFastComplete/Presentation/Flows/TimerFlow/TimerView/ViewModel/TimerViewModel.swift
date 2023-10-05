//
//  TimerViewModel.swift
//  TodayFastComplete
//
//  Created by JongHoon on 9/30/23.
//

import Foundation

import RxCocoa
import RxSwift

final class TimerViewModel: ViewModel {
    struct Input {
        let viewDidLoad: Observable<Void>
        let viewWillAppear: Observable<Void>
        let selectFastModeButtonTapped: Observable<Void>
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
    
    // MARK: - Properties
    private weak var coordinator: Coordinator?
    
    // MARK: - Init
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    deinit {
        Log.deinit()
        coordinator?.finish()
    }
    
    func transform(
        input: Input,
        disposeBag: DisposeBag
    ) -> Output {
        let output = Output()
        
        input.selectFastModeButtonTapped
            .asSignal(onErrorJustReturn: Void())
            .emit(
                with: self,
                onNext: { owner, _ in
                    owner.coordinator?.navigate(to: .timerSettingButtonTapped)
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
