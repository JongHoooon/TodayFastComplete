//
//  WeekDay.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/6/23.
//

enum WeekDay: Int, Hashable, CaseIterable {
    case mon
    case tues
    case wednes
    case thurs
    case fri
    case satur
    case sun
    
    var weekDay: String {
        switch self {
        case .sun:
            Constants.Localization.SUNDAY
        case .mon:
            Constants.Localization.MONDAY
        case .tues:
            Constants.Localization.TUESDAY
        case .wednes:
            Constants.Localization.WEDNESDAY
        case .thurs:
            Constants.Localization.THURSDAY
        case .fri:
            Constants.Localization.FRIDAY
        case .satur:
            Constants.Localization.SATURDAY
        }
    }
}
