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
        let viewDidDisappear: Observable<Void>
        let selectFastModeButtonTapped: Observable<Void>
    }
    
    struct Output {
        // TODO: 단식 설정 안됐을때 문구 입력
        let fastInfo = BehaviorRelay<String>(value: String(""))
        
        let messageText = PublishRelay<String>()
        
        let progressPercent = BehaviorRelay<Double>(value: 0.0)
        let progressTime = BehaviorRelay<TimeInterval>(value: 0)
        let remainTime = BehaviorRelay<TimeInterval>(value: 0)
        
        let currentFastStartTime = BehaviorRelay<Date>(value: Date())
        let currentFastEndTime = BehaviorRelay<Date>(value: Date())
        
        let fastControlButtonTitle = PublishRelay<String>()
    }
    
    // MARK: - Properties
    typealias TimerViewUseCase = RoutineSettingFetchable
    private let timerViewUseCase: TimerViewUseCase
    private weak var coordinator: Coordinator?
    
    private var timerDisposeBag = DisposeBag()
    private let timer = Observable<Int>.timer(
        .seconds(0),
        period: .seconds(1),
        scheduler: ConcurrentDispatchQueueScheduler(queue: .global())
    )
    private let currentRoutineSetting = BehaviorRelay<TimerRoutineSetting?>(value: nil)
    var timerState = BehaviorRelay<TimerState>(value: .noRoutineSetting)
    
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
        
        input.viewWillAppear
            .flatMap { countCurrentTimerState() }
            .subscribe(onNext: { [weak self] state in
                self?.timerState.accept(state)
            })
            .disposed(by: disposeBag)
        
        input.viewDidDisappear
            .bind { [weak self] _ in
                self?.timerDisposeBag = DisposeBag()
            }
            .disposed(by: disposeBag)
            
        let currentRoutineSettingShared = currentRoutineSetting.share()
        
        currentRoutineSettingShared
            .map({
                return $0 == nil
                    ? String(localized: "PLEASE_SET_FAST_TIME", defaultValue: "단식 시간을 설정해 주세요 ⏳")
                    : $0!.routineInfo
            })
            .bind { output.fastInfo.accept($0) }
            .disposed(by: disposeBag)
    
        timerState
            .subscribe(onNext: { state in
                Log.info(state)
                runTimer(state: state)
            })
            .disposed(by: disposeBag)
        
        input.selectFastModeButtonTapped
            .asSignal(onErrorJustReturn: Void())
            .emit(with: self, onNext: { owner, _ in
                owner.coordinator?.navigate(to: .timerSettingButtonTapped(currentRoutineSetting: owner.currentRoutineSetting))
            })
            .disposed(by: disposeBag)
        
        return output
        
        func fetchRoutineSetting() {
            timerViewUseCase.fetchTimerRoutine()
                .subscribe { [weak self] in self?.currentRoutineSetting.accept($0) }
                .disposed(by: disposeBag)
        }
        
        func countCurrentTimerState() -> Observable<TimerState> {
            guard let _ = currentRoutineSetting.value
            else {
                return Observable.just(.noRoutineSetting)
            }
            
            if isNoFastingDay() {
                return Observable.just(.noFastDay)
            }
            
            if isFastTime() {
                return Observable.just(.fastTime)
            }
            
            return Observable.just(.mealTime)
        }
        
        func isNoFastingDay() -> Bool {
            guard let currentRoutineSetting = currentRoutineSetting.value else {
                assertionFailure("currentRoutineSetting value is not exist")
                return false
            }
            
            let isYesterdayFast = currentRoutineSetting.days.contains(WeekDay.theDayBeforRawValue(rawValue: Date().weekDay))
            let isTodayFast = currentRoutineSetting.days.contains(Date().weekDay)
            
            switch (isYesterdayFast, isTodayFast) {
                
            // 오늘 단식이면 false
            case (_, true):
                return false
            
            // 어제 단식이면 어제 단식 끝나는 시간 이전(ascending)이면 안됨
            case (true, false):
                return Date().compare(currentRoutineSetting.yesterdayFastEndTimeDate) != .orderedAscending
                
            default:
                return true
            }
        }
        
        func isFastTime() -> Bool {
            guard let currentRoutineSetting = currentRoutineSetting.value else {
                assertionFailure("currentRoutineSetting value is not exist")
                return false
            }
            
            let isYesterdayFast = currentRoutineSetting.days.contains(WeekDay.theDayBeforRawValue(rawValue: Date().weekDay))
            let isTodayFast = currentRoutineSetting.days.contains(Date().weekDay)
            
            let isBetweenTodayFastTime = Date().compare(currentRoutineSetting.todayFastStartTimeDate) != .orderedAscending && Date().compare(currentRoutineSetting.todayFastEndTimeDate) == .orderedAscending
            
            switch (isYesterdayFast, isTodayFast) {
                
            case (true, true):
                return currentRoutineSetting.isYesterdayFastOnGoing || isBetweenTodayFastTime

            case (true, false):
                return currentRoutineSetting.isYesterdayFastOnGoing
                
            case (false, true):
                return isBetweenTodayFastTime
                
            default:
                return false
            }
        }
        
        func runTimer(state: TimerState) {
            switch state {
            case .fastTime:
                guard let routineSetting = currentRoutineSetting.value else { return }
                output.progressPercent.accept(routineSetting.fastProgressPercent)
                output.currentFastStartTime.accept(routineSetting.currentFastStartDate)
                output.currentFastEndTime.accept(routineSetting.currentFastEndDate)
                
                timerDisposeBag = DisposeBag()
                timer
                    .map { _ in return (1 / routineSetting.startToEndInterval) }
                    .subscribe(onNext: { stack in
                        let currentProgressPercent = output.progressPercent.value
                        output.progressPercent.accept(currentProgressPercent + stack)
                        output.progressTime.accept(routineSetting.fastProgressTime)
                        output.remainTime.accept(routineSetting.fastRemainTime)
                    })
                    .disposed(by: timerDisposeBag)
                
            case .mealTime:
                break
            default:
                break
            }
        }
    }
}
