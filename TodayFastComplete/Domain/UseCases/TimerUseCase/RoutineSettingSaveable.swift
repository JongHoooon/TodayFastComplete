//
//  RoutineSettingSaveable.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/14/23.
//

import RxSwift

protocol RoutineSettingSaveable {
    func saveRoutineSetting(with routineSetting: TimerRoutineSetting) -> Single<TimerRoutineSetting>
}
