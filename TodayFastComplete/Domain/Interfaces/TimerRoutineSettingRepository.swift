//
//  TimerRoutineSettingRepository.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/7/23.
//

import RxSwift

protocol TimerRoutineSettingRepository {
    func update(routineSetting: TimerRoutineSetting) -> Single<TimerRoutineSetting>
    func fetch() -> Single<TimerRoutineSetting?>
}
