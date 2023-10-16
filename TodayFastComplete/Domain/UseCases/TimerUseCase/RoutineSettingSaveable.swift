//
//  RoutineSettingSaveable.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/14/23.
//

import RxSwift

protocol RoutineSettingStoragable {
    func saveRoutineSetting(with routineSetting: TimerRoutineSetting, isDeleteInterruptedDay: Bool) -> Single<TimerRoutineSetting>
    func deleteRoutineSetting() -> Single<Void>
}
