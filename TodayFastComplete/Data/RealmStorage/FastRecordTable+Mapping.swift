//
//  FastRecordTable+Mapping.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/31/23.
//

import Foundation

import RealmSwift

final class FastRecordTable: Object {
    @Persisted(primaryKey: true) var date: String
    @Persisted var startDate: Date
    @Persisted var endDate: Date
    
    convenience init(
        date: Date,
        startDate: Date,
        endDate: Date
    ) {
        self.init()
        self.date = date.toString(format: .yearMonthDayFormat)
        self.startDate = startDate
        self.endDate = endDate
    }
    
    func toDomain() -> FastRecord {
        return FastRecord(
            date: date.toDate(formatter: .yearMonthDayFormat),
            startDate: startDate,
            endDate: endDate
        )
    }
}
