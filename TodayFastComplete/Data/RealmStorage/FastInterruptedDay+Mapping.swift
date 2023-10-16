//
//  FastInterruptedDay+Mapping.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/16/23.
//

import Foundation

import RealmSwift

final class FastInterruptedDayTable: Object {
    @Persisted(primaryKey: true) var uniqueKey = RealmUniqueKey.fastInterruptedDay.rawValue
    @Persisted var interruptedDay: Date
    
    convenience init(
        uniqueKey: String,
        interruptedDay: Date
    ) {
        self.init()
        self.uniqueKey = RealmUniqueKey.fastInterruptedDay.rawValue
        self.interruptedDay = interruptedDay
    }
    
    func toDomain() -> Date {
        return interruptedDay
    }
}
