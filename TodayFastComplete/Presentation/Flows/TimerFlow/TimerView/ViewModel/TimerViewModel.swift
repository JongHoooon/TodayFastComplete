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
        let selectFastModeButtonTapped: Observable<Void>
    }
    
    struct Output {
        // TODO: 단식 설정 안됐을때 문구 입력
        let fastInfo = BehaviorRelay<String>(value: "단식 시간을 설정해 주세요 ⏳")
        
        let messageText = PublishRelay<String>()
        
        let progressTime = BehaviorRelay<DateComponents>(value: Constants.DefaultValue.timerDateComponents)
        let remainTime = BehaviorRelay<DateComponents>(value: Constants.DefaultValue.timerDateComponents)
        
        let todayStartTime = PublishRelay<String>()
        let todayEndTime = PublishRelay<String>()
        
        let fastControlButtonTitle = PublishRelay<String>()
    }
    
    // MARK: - Properties
    typealias TimerViewUseCase = RoutineSettingFetchable
    private let timerViewUseCase: TimerViewUseCase
    private weak var coordinator: Coordinator?
    
    private var currentRoutineSetting = BehaviorRelay<TimerRoutineSetting?>(value: nil)
    
    // MARK: - Init
    init(
        timerViewUseCase: TimerViewUseCase,
        coordinator: Coordinator
    ) {
        self.timerViewUseCase = timerViewUseCase
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
        
        input.viewDidLoad
            .bind { fetchRoutineSetting() }
            .disposed(by: disposeBag)
        
        currentRoutineSetting
            .compactMap { $0 }
            .bind { output.fastInfo.accept($0.routineInfo) }
            .disposed(by: disposeBag)
        
        input.selectFastModeButtonTapped
            .asSignal(onErrorJustReturn: Void())
            .emit(
                with: self,
                onNext: { owner, _ in
                    owner.coordinator?.navigate(to: .timerSettingButtonTapped(currentRoutineSetting: owner.currentRoutineSetting))
            })
            .disposed(by: disposeBag)
        
        return output
        
        func fetchRoutineSetting() {
            timerViewUseCase.fetchTimerRoutine()
                .subscribe(
                    with: self,
                    onSuccess: { owner, routineSetting in
                        if let routineSetting {
                            owner.currentRoutineSetting.accept(routineSetting)
                        } else {
                            
                        }
                })
                .disposed(by: disposeBag)
        }
    }
}
