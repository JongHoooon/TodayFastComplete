//
//  SettingRoutineSection.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/8/23.
//

import Foundation

enum SettingRoutineSection: Int, CaseIterable {
    case dayTime = 0
    case timeSetting
    case recommendRoutine
    case deleteRoutineSetting
    
    var title: String? {
        switch self {
        case .dayTime:
            return String(localized: "SELECT_WEEKDAY", defaultValue: "요일 선택")
        case .timeSetting:
            return String(localized: "TIME_SETTING", defaultValue: "시간 설정")
        case .recommendRoutine:
            return String(localized: "RECOMMEND_FAST_ROUTINE", defaultValue: "추천 단식 루틴")
        case .deleteRoutineSetting:
            return nil
        }
    }
}

enum SettingRoutineItem: Hashable {
    case dayItem(weekDay: WeekDay)
    case timeSettingItem
    case recommendRoutineItem(routine: FastRoutine)
    case deleteRoutineItem
}
