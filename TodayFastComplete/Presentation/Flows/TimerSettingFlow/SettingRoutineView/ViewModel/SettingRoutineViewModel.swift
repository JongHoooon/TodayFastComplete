//
//  SettingRoutineViewModel.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/5/23.
//

import Foundation

import RxRelay
import RxSwift

final class SettingRoutineViewModel: ViewModel {

    struct Input {
        let viewDidLoad: Observable<Void>
        let viewDidDismissed: Observable<Void>
        let dismissButtonTapped: Observable<Void>
        let itemSelected: Observable<IndexPath>
        let timePickerViewTapped: Observable<TimePickerViewType>
        let deleteRoutineSettingButtonTapped: Observable<Void>
        let saveButtonTapped: Observable<Void>
    }
    
    struct Output {
        let sections = SettingRoutineSection.allCases
        let weekDaySectionItems = WeekDay.allCases.map { SettingRoutineItem.dayItem(weekDay: $0) }
        let timeSettingSectionItems = [SettingRoutineItem.timeSettingItem]
        let deleteRoutineSettingSectionItems = [SettingRoutineItem.deleteRoutineItem]
        // TODO: GA 기반 인기순 정렬
        let recommendRoutines = RecommendFastRoutine.allCases
        lazy var recommendSectionItems = recommendRoutines.map {
            SettingRoutineItem.recommendRoutineItem(routine: $0.fastRoutine)
        }
        
        let selectedWeekDays = BehaviorRelay<[Int]>(value: [])
        let selectedRecommendRoutine = BehaviorRelay<Int?>(value: nil)
        
        let selectedStartTime = BehaviorRelay<DateComponents>(value: Constants.DefaultValue.startTime)
        let selectedFastTime = BehaviorRelay<Int>(value: Constants.DefaultValue.fastTime)
        
        let selectedRoutineInfo = BehaviorRelay<String>(value: "")
        
        let saveButtonIsEnable = BehaviorRelay<Bool>(value: false)
        
        let deleteButtonIsEnable = BehaviorRelay<Bool>(value: false)
    }
    
    typealias SettingTimerRoutineUseCase = RoutineSettingFetchable & RoutineSettingStoragable
    private let settingTimerRoutineUseCase: SettingTimerRoutineUseCase
    private weak var coordinator: Coordinator?
    private let disposeBag = DisposeBag()
    
    private var currentRoutineSetting: BehaviorRelay<TimerRoutineSetting?>
    
    init(
        settingTimerRoutineUseCase: SettingTimerRoutineUseCase,
        coordinator: Coordinator,
        currentRoutineSetting: BehaviorRelay<TimerRoutineSetting?>
    ) {
        self.settingTimerRoutineUseCase = settingTimerRoutineUseCase
        self.coordinator = coordinator
        self.currentRoutineSetting = currentRoutineSetting
    }
    
    deinit {
        Log.deinit()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        let recommendSectionNeedDeselect = PublishRelay<Void>()
        
        input.viewDidLoad
            .bind { fetchTimerRoutineSetting() }
            .disposed(by: disposeBag)
        
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
                    owner.coordinator?.navigate(to: .settingTimerFlowIsComplete)
                })
            .disposed(by: disposeBag)
        
        let itemSelected = input.itemSelected.share()
        
        itemSelected
            .filter { $0.section == SettingRoutineSection.dayTime.rawValue }
            .map { $0.item }
            .map { WeekDay.allCases[$0].rawValue }
            .map { selectedDayRawValue in
                let currentSelectedDays = output.selectedWeekDays.value
                return currentSelectedDays.contains(selectedDayRawValue)
                ? currentSelectedDays.filter { $0 != selectedDayRawValue }
                : currentSelectedDays + [selectedDayRawValue]
            }
            .bind { output.selectedWeekDays.accept($0) }
            .disposed(by: disposeBag)
        
        itemSelected
            .filter { $0.section == SettingRoutineSection.recommendRoutine.rawValue }
            .map { $0.item }
            .bind { output.selectedRecommendRoutine.accept($0) }
            .disposed(by: disposeBag)
        
        itemSelected
            .filter { $0.section == SettingRoutineSection.recommendRoutine.rawValue }
            .map { $0.item }
            .map { output.recommendRoutines[$0].fastRoutine.fastingTime }
            .bind { output.selectedFastTime.accept($0) }
            .disposed(by: disposeBag)

        input.timePickerViewTapped
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(with: self, onNext: { owner, type in
                switch type {
                case .startTime:
                    owner.coordinator?.navigate(to: .settingStartTimePickerViewTapped(
                        selectedStartTime: output.selectedStartTime,
                        initialStartTime: output.selectedStartTime.value
                    ))
                case .fastTime:
                    guard let coordinator = owner.coordinator
                    else {
                        assertionFailure("coordinator is not linked")
                        return
                    }
                    coordinator.navigate(to: .settingFastTimePickerViewTapped(
                        selectedFastTime: output.selectedFastTime,
                        recommendSectionNeedDeselect: recommendSectionNeedDeselect, 
                        initialFastTime: output.selectedFastTime.value
                    ))
                }
            })
            .disposed(by: disposeBag)
        
        recommendSectionNeedDeselect
            .map { _ in nil }
            .bind { output.selectedRecommendRoutine.accept($0) }
            .disposed(by: disposeBag)
        
        output.selectedWeekDays
            .map { !$0.isEmpty }
            .bind { output.saveButtonIsEnable.accept($0) }
            .disposed(by: disposeBag)
        
        input.saveButtonTapped
            .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.asyncInstance)
            .map({
                return TimerRoutineSetting(
                    days: output.selectedWeekDays.value,
                    startTime: output.selectedStartTime.value,
                    fastTime: output.selectedFastTime.value
            )})
            .withUnretained(self)
            .flatMap({ owner, routineSetting in
                return owner.settingTimerRoutineUseCase.saveRoutineSetting(with: routineSetting)
            })
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(
                with: self,
                onNext: { owner, timerRoutineSetting in
                    owner.currentRoutineSetting.accept(timerRoutineSetting)
                    owner.coordinator?.navigate(to: .settingTimerFlowIsComplete)
                },
                onError: { _, error in
                    // TODO: Error handling 수정 필요
                    Log.error(error)
            })
            .disposed(by: disposeBag)
        
        let deleteAlertActionRelay =  PublishRelay<AlertActionType>()
        input.deleteRoutineSettingButtonTapped
            .throttle(
                .milliseconds(500),
                latest: false,
                scheduler: MainScheduler.asyncInstance
            )
            .observe(on: MainScheduler.asyncInstance)
            .bind(with: self, onNext: { owner, _ in
                owner.coordinator?.navigate(to: .deleteRoutineSettingButtonTapped(deleteAlertActionRelay: deleteAlertActionRelay))
            })
            .disposed(by: disposeBag)
        
//            .bind { [weak self] in
//                guard let self else { return }
//                self.coordinator?.navigate(to: .deleteRoutineSettingButtonTapped(deleteAlertActionRelay: deleteAlertActionRelay))
//            }
//            .disposed(by: disposeBag)
        
//        deleteAlertActionRelay
//            .asSignal()
//            .emit(
//                with: self,
//                onNext: { owner, actionType in
//                    switch actionType {
//                    case .ok:
//                        owner.settingTimerRoutineUseCase.deleteRoutineSetting()
//                            .observe(on: MainScheduler.asyncInstance)
//                            .subscribe(
//                                onCompleted: { [weak self] in
//                                    self?.currentRoutineSetting.accept(nil)
//                                    self?.coordinator?.navigate(to: .settingTimerFlowIsComplete)
//                                },
//                                onError: { error in
//                                    Log.error(error)
//                            })
//                            .disposed(by: owner.disposeBag)
//                    case .cancel:
//                        break
//                    }
//            })
//            .disposed(by: disposeBag)
        
        deleteAlertActionRelay
            .filter { $0 == .ok }
            .flatMap { [unowned self] _ in return self.settingTimerRoutineUseCase.deleteRoutineSetting() }
            .observe(on: MainScheduler.asyncInstance)
            .bind { [weak self] _ in
                self?.coordinator?.navigate(to: .settingTimerFlowIsComplete)
            }
            .disposed(by: disposeBag)
        
//        func deleteRoutineSetting() {
//            settingTimerRoutineUseCase.deleteRoutineSetting()
//                .observe(on: MainScheduler.asyncInstance)
//                .subscribe(
//                    onCompleted: { [weak self] in
//                        self?.currentRoutineSetting.accept(nil)
//                        self?.coordinator?.navigate(to: .settingTimerFlowIsComplete)
//                    },
//                    onError: { error in
//                        Log.error(error)
//                })
//                .disposed(by: disposeBag)
//        }
        
        BehaviorRelay.combineLatest(
            output.selectedWeekDays,
            output.selectedStartTime,
            output.selectedFastTime
        )
        .map {
            let weekDays = $0.0
            let startTime = $0.1
            let fastTime = $0.2
            var days = WeekDay.allCases
                .filter { weekDays.contains($0.rawValue) == true }
                .map { $0.weekDayName }
                .joined(separator: ", ")
            if days == "" {
                days = Constants.Localization.PLEASE_SELECT_WEEKDAYS
            }
            let fastStartTime = startTime.timeString
            let mealStartTime = DateComponents(
                hour: (startTime.hour ?? 0) + fastTime,
                minute: startTime.minute
            ).timeString
            return String(
                format: Constants.Localization.TIMER_VIEW_FAST_INFO,
                arguments: [
                    days,
                    fastStartTime, mealStartTime, fastTime,
                    mealStartTime, fastStartTime, (24-fastTime)
                ])
        }
        .bind {
            output.selectedRoutineInfo.accept($0)
        }
        .disposed(by: disposeBag)
        
        return output
        
        func fetchTimerRoutineSetting() {
            settingTimerRoutineUseCase.fetchTimerRoutine()
                .subscribe(onSuccess: { routineSetting in
                    guard let routineSetting else {
                        output.deleteButtonIsEnable.accept(false)
                        return
                    }
                    output.deleteButtonIsEnable.accept(true)
                    output.selectedWeekDays.accept(routineSetting.days)
                    output.selectedStartTime.accept(routineSetting.startTime)
                    output.selectedFastTime.accept(routineSetting.fastTime)
                })
                .disposed(by: disposeBag)
        }
    }
}
