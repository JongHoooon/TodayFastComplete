//
//  WeekDay.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/6/23.
//

enum WeekDay: Int, Hashable, CaseIterable {
    case mon = 2
    case tues = 3
    case wednes = 4
    case thurs = 5
    case fri = 6
    case satur = 7
    case sun = 1
    
    var weekDayName: String {
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
