//
//  TimerUseCaseImp.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/9/23.
//

import Foundation

import RxSwift

typealias TimerUseCase = RoutineSettingUpdatable & RoutineSettingFetchable

final class TimerUseCaseImp: TimerUseCase {
    private let routineSettingRepository: TimerRoutineSettingRepository
    
    init(routineSettingRepository: TimerRoutineSettingRepository) {
        self.routineSettingRepository = routineSettingRepository
    }
    
    func updateRouineSetting(with routineSeting: TimerRoutineSetting) -> Single<TimerRoutineSetting> {
        return routineSettingRepository.update(routineSetting: routineSeting)
    }
    
    func fetchTimerRoutine() -> Single<TimerRoutineSetting?> {
        return routineSettingRepository.fetchRoutine()
    }
}
