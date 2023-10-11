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
    
    /// "2018-05-13 15:05:40"
    static var dateTimeFormat: DateFormatter {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return format
    }
    
    static func toString(
        date: Date,
        format: DateFormatter
    ) -> String {
        return format.string(from: date)
    }
}
