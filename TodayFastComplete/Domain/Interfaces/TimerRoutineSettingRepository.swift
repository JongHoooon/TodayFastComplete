//
//  TimerRoutineSettingRepository.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/7/23.
//

import RxSwift

protocol TimerRoutineSettingRepository {
    func update(routineSetting: TimerRoutineSetting) -> Single<TimerRoutineSetting>
    func fetchRoutine() -> Single<TimerRoutineSetting?>
    func deleteRoutine() -> Single<TimerRoutineSetting>
}
