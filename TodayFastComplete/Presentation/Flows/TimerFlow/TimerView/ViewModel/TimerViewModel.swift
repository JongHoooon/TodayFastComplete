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
        let progressViewEndpoinButtonTapped: Observable<Void>
        let setTimerButtonTapped: Observable<Void>
    }
    
    struct Output {
        // TODO: 단식 설정 안됐을때 문구 입력
        let fastInfo = BehaviorRelay<String>(value: String(""))
        
        let messageText = PublishRelay<String>()
        
        let progressPercent = BehaviorRelay<Double>(value: 0.0)
        let progressTime = BehaviorRelay<TimeInterval>(value: 0)
        let remainTime = BehaviorRelay<TimeInterval>(value: 0)
        let remainTimeLabelIsHiddend = BehaviorRelay<Bool>(value: true)
        
        let currentLoopTimeLabelIsHidden = BehaviorRelay<Bool>(value: false)
        let currentLoopStartTime = BehaviorRelay<Date>(value: Date())
        let currentLoopEndTime = BehaviorRelay<Date>(value: Date())
        
        let endpointButtonTitle = BehaviorRelay<String>(value: "0%")
        
        let fastControlButtonIsEnabled = BehaviorRelay<Bool>(value: false)
        let fastControlButtonTitle = PublishRelay<String>()
    }
    
    // MARK: - Properties
    typealias TimerViewUseCase = RoutineSettingFetchable
    private let timerViewUseCase: TimerViewUseCase
    private weak var coordinator: Coordinator?
    
    private var timerDisposeBag = DisposeBag()
    private let loopTimer = Observable<Int>.timer(
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
            .bind { [weak self] in
                guard let self else { return }
                countCurrentTimerState()
                configureMessageLabel(state: self.timerState.value)
            }
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
                configureMessageLabel(state: state)
                configureLoopLabels(state: state)
                configureFastControlButton(state: state)
                configureTimer(state: state)
            })
            .disposed(by: disposeBag)
        
        var endpointString: [String] {
            ["\(Int(output.progressPercent.value * 100))%", "🔥", "💪", "🤐", "❌", "🚫", "🚨", "🏃🏻", "🏃🏼‍♀️"]
        }
        var endpointStringIndex = 1
        input.progressViewEndpoinButtonTapped
            .bind { _ in
                output.endpointButtonTitle.accept(endpointString[endpointStringIndex])
                endpointStringIndex += 1
                if endpointStringIndex >= endpointString.count {
                    endpointStringIndex %= endpointString.count
                }
            }
            .disposed(by: disposeBag)
        
        input.setTimerButtonTapped
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
        
        func countCurrentTimerState() {
            guard let _ = currentRoutineSetting.value
            else {
                timerState.accept(.noRoutineSetting)
                return
            }
            
            if isNoFastDay() {
                timerState.accept(.noFastDay)
                return
            }
            
            if isFastTime() {
                timerState.accept(.fastTime)
                return
            }
            
            timerState.accept(.mealTime)
            return
        }
        
        func isNoFastDay() -> Bool {
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
        
        func configureMessageLabel(state: TimerState) {
            switch state {
            case .fastTime:
                output.messageText.accept(String(localized: "FAST_TIME_MESSAGE_1", defaultValue: "지방이 타고 있어요 🔥"))
            case .mealTime:
                output.messageText.accept(String(
                    localized: "MEAL_TIME_MESSAGE_1",
                    defaultValue: "식사시간 입니다 \(["🍜", "🍕", "🍔", "🍲", "🍱", "🍽️", "🥙", "🥗"].randomElement() ?? "🍽️")"
                ))
            case .noFastDay:
                output.messageText.accept(String(localized: "NO_FAST_TIME_MESSAGE_1", defaultValue: "오늘은 단식이 없어요 🥳"))
            case .noRoutineSetting:
                output.messageText.accept(String(localized: "NO_ROUTINE_SETTING", defaultValue: "단식 시간을 설정해주세요 😊"))
            }
        }
        
        func configureLoopLabels(state: TimerState) {
            switch state {
            case .fastTime:
                guard let routineSetting = currentRoutineSetting.value else { return }
                output.currentLoopTimeLabelIsHidden.accept(false)
                output.currentLoopStartTime.accept(routineSetting.currentFastStartDate)
                output.currentLoopEndTime.accept(routineSetting.currentFastEndDate)
                
            case .mealTime:
                guard let routineSetting = currentRoutineSetting.value else { return }
                output.currentLoopTimeLabelIsHidden.accept(false)
                output.currentLoopStartTime.accept(routineSetting.currentMealStartDate)
                output.currentLoopEndTime.accept(routineSetting.currentMealEndDate)
                
            case .noFastDay:
                output.currentLoopTimeLabelIsHidden.accept(true)
                
            case .noRoutineSetting:
                output.currentLoopTimeLabelIsHidden.accept(true)
            }
        }
        
        func configureTimer(state: TimerState) {
            switch state {
            case .fastTime:
                guard let routineSetting = currentRoutineSetting.value else { return }
                output.progressPercent.accept(routineSetting.fastProgressPercent)
                output.remainTimeLabelIsHiddend.accept(false)
                
                timerDisposeBag = DisposeBag()
                loopTimer
                    .map { _ in return (1 / routineSetting.FaststartToFastEndInterval) }
                    .do(onNext: { [weak self] _ in
                        if output.progressPercent.value >= 1.0 {
                            self?.timerDisposeBag = DisposeBag()
                            countCurrentTimerState()
                        }
                    })
                    .subscribe(onNext: { stack in
                        let currentProgressPercent = output.progressPercent.value
                        output.progressPercent.accept(currentProgressPercent + stack)
                        output.progressTime.accept(routineSetting.fastProgressTime)
                        output.remainTime.accept(routineSetting.fastRemainTime)
                    })
                    .disposed(by: timerDisposeBag)
                
            case .mealTime:
                guard let routineSetting = currentRoutineSetting.value else { return }
                output.progressPercent.accept(1.0)
                output.progressTime.accept(TimeInterval())
                output.remainTimeLabelIsHiddend.accept(false)
                
                timerDisposeBag = DisposeBag()
                loopTimer
                    .do(afterNext: { _ in
                        if Date().compare(routineSetting.currentMealEndDate) != .orderedAscending {
                            countCurrentTimerState()
                        }
                    })
                    .subscribe(onNext: { _ in
                        output.remainTime.accept(routineSetting.mealRemainTime)
                    })
                    .disposed(by: timerDisposeBag)
                
            case .noFastDay:
                output.progressPercent.accept(0.0)
                output.progressTime.accept(TimeInterval())
                output.remainTime.accept(TimeInterval())
                output.remainTimeLabelIsHiddend.accept(true)
                
                let nowToMidnightInterval = Calendar.current
                    .date(
                        bySettingHour: 0,
                        minute: 0,
                        second: 0,
                        of: Date().addingTimeInterval(24*3600)
                    )?
                    .timeIntervalSinceNow ?? 0
                
                timerDisposeBag = DisposeBag()
                Observable<Int>.timer(.seconds(Int(nowToMidnightInterval)), scheduler: ConcurrentDispatchQueueScheduler(queue: .global()))
                    .subscribe(onNext: { _ in
                        countCurrentTimerState()
                    })
                    .disposed(by: timerDisposeBag)
                
            case .noRoutineSetting:
                output.progressPercent.accept(0.0)
                output.progressTime.accept(TimeInterval())
                output.remainTime.accept(TimeInterval())
                output.remainTimeLabelIsHiddend.accept(true)
            }
        }
        
        func configureFastControlButton(state: TimerState) {
            switch state {
            case .fastTime:
                output.fastControlButtonIsEnabled.accept(true)
            case .mealTime:
                output.fastControlButtonIsEnabled.accept(true)
            case .noFastDay:
                output.fastControlButtonIsEnabled.accept(false)
            case .noRoutineSetting:
                output.fastControlButtonIsEnabled.accept(false)
            }
        }
    }
}
