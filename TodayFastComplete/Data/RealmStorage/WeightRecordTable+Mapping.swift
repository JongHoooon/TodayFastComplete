//
//  WeightRecordTable+Mapping.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/31/23.
//

import Foundation

import RealmSwift

final class WeightRecordTable: Object {
    @Persisted(primaryKey: true) var date: String
    @Persisted var weight: Double
    
    convenience init(
        date: Date,
        weight: Double
    ) {
        self.init()
        self.date = date.toString(format: .yearMonthDayFormat)
        self.weight = weight
    }
    
    func toDomain() -> WeightRecord {
        return WeightRecord(
            date: date.toDate(formatter: .yearMonthDayFormat),
            weight: weight
        )
    }
}
