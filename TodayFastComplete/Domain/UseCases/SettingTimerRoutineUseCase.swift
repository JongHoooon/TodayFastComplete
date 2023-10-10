//
//  SettingTimerRoutineUseCase.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/9/23.
//

import Foundation

import RxSwift

protocol SettingTimerRoutineUseCase {
    func updateRoutine(routineSeting: TimerRoutineSetting) -> Single<TimerRoutineSetting>
    func fetchTimerRoutine() -> Single<TimerRoutineSetting?>
}

final class DefaultSettingTimerRoutineUseCase: SettingTimerRoutineUseCase {
    private let routineSettingRepository: TimerRoutineSettingRepository
    
    init(routineSettingRepository: TimerRoutineSettingRepository) {
        self.routineSettingRepository = routineSettingRepository
    }
    
    func updateRoutine(routineSeting: TimerRoutineSetting) -> Single<TimerRoutineSetting> {
        return routineSettingRepository.update(routineSetting: routineSeting)
    }
    
    func fetchTimerRoutine() -> Single<TimerRoutineSetting?> {
        return routineSettingRepository.fetchRoutine()
    }
}
