//
//  RoutineSettingFetchable.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/10/23.
//

import RxSwift

protocol RoutineSettingFetchable {
    func fetchTimerRoutine() -> Single<TimerRoutineSetting?>
}
