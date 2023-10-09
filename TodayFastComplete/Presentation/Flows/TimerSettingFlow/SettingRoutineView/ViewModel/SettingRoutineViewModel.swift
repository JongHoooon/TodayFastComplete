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
    }
    
    struct Output {
        let sections = SettingRoutineSection.allCases
        let weekDayItems = WeekDay.allCases.map { SettingRoutineItem.dayItem(weekDay: $0) }
        let timeSettingItems = [SettingRoutineItem.timeSetting]
        // TODO: GA 기반 인기순 정렬
        let recommendRoutines = RecommendFastRoutine.allCases
        lazy var recommendItems = recommendRoutines.map {
            SettingRoutineItem.recommendRoutineItem(routine: $0.fastRoutine)
        }
        // TODO: view did 로드에서 저장된값있으면 넣주게 해야함
        let selectedWeekDays = BehaviorRelay<[Int]>(value: [])
        let selectedRecommendRoutine = BehaviorRelay<Int?>(value: nil)
        
        let selectedStartTime = BehaviorRelay<Date>(value: Constants.DefaultValue.startTime)
        let selectedFastTime = BehaviorRelay<Int>(value: Constants.DefaultValue.fastTime)
        
        let saveButtonIsEnable = BehaviorRelay<Bool>(value: false)
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
        let recommendSectionNeedDeselect = PublishRelay<Void>()
        
        input.viewDidLoad
            .debug()
            .bind(onNext: { _ in
                
            })
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
            .debug()
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
        
        return output
    }
}
