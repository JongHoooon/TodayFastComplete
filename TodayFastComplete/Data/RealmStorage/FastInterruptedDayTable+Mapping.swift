//
//  FastInterruptedDayTable+Mapping.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/16/23.
//

import Foundation

import RealmSwift

final class FastInterruptedDayTable: Object {
    @Persisted(primaryKey: true) var uniqueKey = RealmUniqueKey.fastInterruptedDay.rawValue
    @Persisted var interruptedDate: Date
    @Persisted var interruptedFastEndDate: Date
    
    convenience init(
        uniqueKey: String,
        interruptedDay: Date,
        interruptedFastEndDate: Date
    ) {
        self.init()
        self.uniqueKey = RealmUniqueKey.fastInterruptedDay.rawValue
        self.interruptedDate = interruptedDay
        self.interruptedFastEndDate = interruptedFastEndDate
    }
    
    func toDomain() -> InterruptedFast {
        return InterruptedFast(
            interruptedDate: interruptedDate,
            interruptedFastEndDate: interruptedFastEndDate
        )
    }
}
