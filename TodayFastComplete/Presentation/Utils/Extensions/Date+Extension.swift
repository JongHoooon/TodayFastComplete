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
    
    var year: Int {
        guard let year = Calendar.current.dateComponents([.year], from: self).year
        else {
            assertionFailure("no year")
            return -1
        }
        return year
    }
    
    var month: Int {
        guard let month = Calendar.current.dateComponents([.month], from: self).month
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
    
    var previousWeek: Date {
        return Calendar.current.date(byAdding: .weekOfMonth, value: -1, to: self) ?? Date()
    }
    
    var nextWeek: Date {
        return Calendar.current.date(byAdding: .weekOfMonth, value: +1, to: self) ?? Date()
    }
    
    var previousMonth: Date {
        return Calendar.current.date(byAdding: .month, value: -1, to: self) ?? Date()
    }
    
    var nextMonth: Date {
        return Calendar.current.date(byAdding: .month, value: +1, to: self) ?? Date()
    }
    
    var second: Int {
        guard let second = Calendar.current.dateComponents([.second], from: self).second
        else {
            assertionFailure("no second")
            return -1
        }
        return second
    }
    
    static func < (lhs: Date, rhs: Date) -> Bool {
        return lhs.compare(rhs) == .orderedAscending
    }
    
    static func <= (lhs: Date, rhs: Date) -> Bool {
        return lhs.compare(rhs) != .orderedDescending
    }
    
    static func == (lhs: Date, rhs: Date) -> Bool {
        return lhs.compare(rhs) == .orderedSame
    }
    
    static func > (lhs: Date, rhs: Date) -> Bool {
        return lhs.compare(rhs) == .orderedDescending
    }
    
    static func >= (lhs: Date, rhs: Date) -> Bool {
        return lhs.compare(rhs) != .orderedAscending
    }
}
