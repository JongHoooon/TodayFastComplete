//
//  RoutineSettingUpdatable.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/10/23.
//

import RxSwift

protocol RoutineSettingUpdatable {
    func updateRouineSetting(with routineSetting: TimerRoutineSetting) -> Single<TimerRoutineSetting>
}
