//
//  TimerRoutineSetting.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/7/23.
//

import Foundation

struct TimerRoutineSetting {
    var days: [Int]
    var startTime: DateComponents
    var fastTime: Int
    var mealTime: Int {
        return 24 - fastTime
    }
    
    init(
        days: [Int],
        startTime: DateComponents,
        fastTime: Int
    ) {
        self.days = days
        self.startTime = startTime
        self.fastTime = fastTime
    }
    
    var routineInfo: String {
        let days = WeekDay.allCases
            .filter { self.days.contains($0.rawValue) == true }
            .map { $0.weekDayName }
            .joined(separator: ", ")
        let fastStartTime = startTime.timeString
        let mealStartTime = DateComponents(
            hour: (startTime.hour ?? 0) + fastTime,
            minute: startTime.minute
        ).timeString
        return String(
            localized: "TIMER_VIEW_FAST_INFO",
            defaultValue: """
            단식 요일: \(days)
            단식 시간: \(fastStartTime) - \(mealStartTime) \(fastTime)시간
            식사 시간: \(mealStartTime) - \(fastStartTime) \(24 - fastTime)시간
            """
        )
    }
}
