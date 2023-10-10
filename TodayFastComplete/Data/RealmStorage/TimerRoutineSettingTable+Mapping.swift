//
//  TimerRoutineSettingTable+Mapping.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/7/23.
//

import Foundation

import RealmSwift

final class TimerRoutineSettingTable: Object {
    @Persisted(primaryKey: true) var uniqueKey = RealmUniqueKey.fastRoutineSetting.rawValue
    @Persisted var days: List<Int>
    @Persisted var startTimeHour: Int
    @Persisted var startTimeMinute: Int
    @Persisted var fastTime: Int
    
    override class func primaryKey() -> String? {
        return RealmUniqueKey.fastRoutineSetting.rawValue
    }
    
    convenience init(
        uniqueKey: String = RealmUniqueKey.fastRoutineSetting.rawValue,
        days: List<Int>,
        startTimeHour: Int,
        startTimeMinute: Int,
        fastTime: Int
    ) {
        self.init()
        self.uniqueKey = uniqueKey
        self.days = days
        self.startTimeHour = startTimeHour
        self.startTimeMinute = startTimeMinute
        self.fastTime = fastTime
    }
    
    func toDomain() -> TimerRoutineSetting {
        return TimerRoutineSetting(
            days: days.toArray(),
            startTime: DateComponents(hour: startTimeHour, minute: startTimeMinute),
            fastTime: fastTime
        )
    }
}
