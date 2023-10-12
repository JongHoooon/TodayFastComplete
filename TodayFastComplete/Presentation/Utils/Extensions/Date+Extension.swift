//
//  Date+Extension.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/10/23.
//

import Foundation

extension Date {
    
    func toString(format: DateFormatter) -> String {
        return DateFormatter.toString(date: self, format: format)
    }
    
    /// 시, 분, 초 date components
    var timeDateComponents: DateComponents {
        return Calendar.current.dateComponents([.hour, .minute, .second], from: self)
    }
    
    var month: Int {
        guard let month = Calendar.current.dateComponents([.minute], from: self).month
        else {
            assertionFailure("no month")
            return -1
        }
        return month
    }
    
    var day: Int {
        guard let day = Calendar.current.dateComponents([.day], from: self).day
        else {
            assertionFailure("no day")
            return -1
        }
        return day
    }
    
    var weekDay: Int {
        guard let weekDayComponent = Calendar.current.dateComponents([.weekday], from: self).weekday
        else {
            assertionFailure("no weekday")
            return -1
        }
        return weekDayComponent
    }

    var hour: Int {
        guard let hour = Calendar.current.dateComponents([.hour], from: self).hour 
        else {
            assertionFailure("no hour")
            return -1
        }
        return hour
    }
    
    var minute: Int {
        guard let minute = Calendar.current.dateComponents([.minute], from: self).minute 
        else {
            assertionFailure("no minute")
            return -1
        }
        return minute
    }
    
    var second: Int {
        guard let second = Calendar.current.dateComponents([.second], from: self).second
        else {
            assertionFailure("no second")
            return -1
        }
        return second
    }
}
