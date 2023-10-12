//
//  TimeInterval+Extension.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/12/23.
//

import Foundation

extension TimeInterval {
    /// hour, minute, second 
    var toTimeDateComponents: DateComponents {
        let interval = Int(self)
        let hour = interval.hour
        let minute = interval.minute
        let second = interval.second
        return DateComponents(hour: hour, minute: minute, second: second)
    }
    
    var timerString: String {
        toTimeDateComponents.timerString
    }
}
