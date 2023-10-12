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
    
    var todayFastStartTimeDate: Date {
        let todayFastTimeDate = Calendar.current.date(
            bySettingHour: startTime.hour ?? 0,
            minute: startTime.minute ?? 0,
            second: 0,
            of: Date()
        )
        return todayFastTimeDate ?? Date()
    }
    
    var todayFastEndTimeDate: Date {
        let todayFastEndTimeDate = todayFastStartTimeDate.addingTimeInterval(TimeInterval(fastTime * 3600))
        return todayFastEndTimeDate
    }
    
    var yesterdayFastStartTimeDate: Date {
        let yesterdayDate = Date().addingTimeInterval(TimeInterval(-24 * 3600))
        let yesterdayFastTimeDate =  Calendar.current.date(
            bySettingHour: startTime.hour ?? 0,
            minute: startTime.minute ?? 0,
            second: 0,
            of: yesterdayDate
        )
        return yesterdayFastTimeDate ?? Date()
    }
    
    var yesterdayFastEndTimeDate: Date {
        let yesterdayFastEndTimeDate = yesterdayFastStartTimeDate.addingTimeInterval(TimeInterval(fastTime * 3600))
        return yesterdayFastEndTimeDate
    }
    
    var startToEndInterval: TimeInterval {
        todayFastStartTimeDate.distance(to: todayFastEndTimeDate)
    }
    
    var nowToFastEndInterval: TimeInterval {
        todayFastEndTimeDate.timeIntervalSinceNow
    }
    
    var nowToYesterdayFastEndInterval: TimeInterval {
        yesterdayFastEndTimeDate.timeIntervalSinceNow
    }
    
    var todayFastStartToNow: TimeInterval {
        todayFastStartTimeDate.distance(to: Date())
    }
    
    var yesterdayFastStartToNow: TimeInterval {
        yesterdayFastStartTimeDate.distance(to: Date())
    }
    
    var nowToFastStartInterval: TimeInterval {
        todayFastStartTimeDate.timeIntervalSinceNow
    }
    
    var todayFastProgressPerecent: Double {
        Double(Int(todayFastStartToNow)) / Double(Int(startToEndInterval))
    }
    
    var yesterdayFastProgressPercent: Double {
        Double(Int(yesterdayFastStartToNow)) / Double(Int(startToEndInterval))
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
