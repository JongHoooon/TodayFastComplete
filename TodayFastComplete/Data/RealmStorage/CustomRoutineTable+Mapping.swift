//
//  CustomRoutineTable+Mapping.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/8/23.
//

import Foundation

import RealmSwift

final class CustomRoutineTable: Object {
    @Persisted(primaryKey: true) var fastTime: Int
    var lastUseTime: Date?
    
    convenience init(
        fastTime: Int
    ) {
        self.init()
        self.fastTime = fastTime
        self.lastUseTime = nil
    }
    
    func toDomain() -> FastRoutine {
        return FastRoutine(fastingTime: fastTime)
    }
}
