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
    }
    
    struct Output {
        let sections = SettingRoutineSection.allCases
        let weekDayItems = WeekDay.allCases.map { SettingRoutineItem.dayItem(weekDay: $0) }
        let timeSettingItems = [SettingRoutineItem.timeSetting]
        // TODO: GA 기반 인기순 정렬
        let recommendItems = RecommendFastRoutine.allCases.map {
            SettingRoutineItem.recommendRoutineItem(routine: $0.fastRoutine)
        }
        // TODO: view did 로드에서 저장된값있으면 넣주게 해야함
        let selectedWeekDays = BehaviorRelay<[Int]>(value: [])
        let selectedRecommendRoutine = BehaviorRelay<Int?>(value: nil)
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
                    owner.coordinator?.navigate(to: .settingTimerFlowDismissButtonTapped)
            })
            .disposed(by: disposeBag)
        
        input.itemSelected
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
        
        input.itemSelected
            .filter { $0.section == SettingRoutineSection.recommendRoutine.rawValue }
            .map { $0.item }
            .bind { output.selectedRecommendRoutine.accept($0) }
            .disposed(by: disposeBag)
        
        return output
    }
}
