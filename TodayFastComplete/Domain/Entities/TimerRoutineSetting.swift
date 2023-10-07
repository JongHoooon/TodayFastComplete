//
//  TimerRoutineSetting.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/7/23.
//

struct TimerRoutineSetting {
    var days: [Int]
    var startTime: Time
    var fastTime: Int
    var mealTime: Int {
        return 24 - fastTime
    }
    
    init(days: [Int], startTime: Time, fastTime: Int) {
        self.days = days
        self.startTime = startTime
        self.fastTime = fastTime
    }
}
