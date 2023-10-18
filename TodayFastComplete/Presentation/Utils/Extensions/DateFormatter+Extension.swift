//
//  DateFormatter+Extension.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/9/23.
//

import Foundation

extension DateFormatter {
    
    /// a h시 m분
    /// 오후 2시 23분
    static var hourMinuteFormat: DateFormatter {
        let format = DateFormatter()
        format.dateFormat = "a h:mm"
        return format
    }
    
    /// 11 : 22 : 33
    static var timerHourMinuteSecondFormat: DateFormatter {
        let format = DateFormatter()
        format.dateFormat = "HH : mm : ss"
        return format
    }
    
    static var currentFastTimeFormat: DateFormatter {
        let format = DateFormatter()
        format.dateFormat = String(
            localized: "CURRENT_FAST_TIME_FORMAT",
            defaultValue: "M월 d일 H시 m분"
        )
        return format
    }
    
    /// "2018-05-13 15:05:40"
    static var dateTimeFormat: DateFormatter {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return format
    }
    
    /// 2018-10-18
    static var yearMonthDayFormat: DateFormatter {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        return format
    }
    
    static func toString(
        date: Date,
        format: DateFormatter
    ) -> String {
        return format.string(from: date)
    }
}
