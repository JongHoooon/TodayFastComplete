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
    }
    
    struct Output {
        let sections = SettingRoutineSection.allCases
        let weekDayItems = WeekDay.allCases.map { SettingRoutineItem.dayItem(weekDay: $0) }
        let timeSetting = [SettingRoutineItem.timeSetting]
        let recommendItems = RecommendFastRoutine.allCases.map {
            SettingRoutineItem.recommendRoutineItem(routine: $0.fastRoutine)
        }

//        let settingRoutineSections = BehaviorRelay<[SettingRoutineSection]>(value: [])
//        let weekDaysSectionItems = BehaviorRelay<[SettingRoutineItem]>(value: [])
//        let settingRoutineSectionItems = BehaviorRelay<[SettingRoutineItem]>(value: [])
//        let recommendRoutineSectionItems = BehaviorRelay<[SettingRoutineItem]>(value: [])
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
        
        return output
    }
}
