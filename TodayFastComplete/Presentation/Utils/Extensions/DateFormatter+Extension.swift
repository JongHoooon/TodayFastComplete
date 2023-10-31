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
    
    /// 10월 23일 오후 8:52
    static var monthDayTimeFormat: DateFormatter {
        let format = DateFormatter()
        format.dateFormat = Constants.Localization.MONTH_DAY_TIME_FORMAT
        return format
    }
    
    /// 2023년 10월 19일 목요일
    static var yearMonthDayWeekDayFormat: DateFormatter {
        let format = DateFormatter()
        format.dateFormat = Constants.Localization.YEAR_MONTH_DAY_FORMAT
        return format
    }
    
    /// 11 : 22 : 33
    static var timerHourMinuteSecondFormat: DateFormatter {
        let format = DateFormatter()
        format.dateFormat = "HH : mm : ss"
        return format
    }
    
    /// M월 d일 H시 m분
    static var currentFastTimeFormat: DateFormatter {
        let format = DateFormatter()
        format.dateFormat = String(
            localized: "CURRENT_FAST_TIME_FORMAT",
            defaultValue: "M월 d일 H:mm"
        )
        return format
    }
    
    /// M월 d일 a h시 m분
    static var currentFastTimeFormat2: DateFormatter {
        let format = DateFormatter()
        format.dateFormat = String(
            localized: "CURRENT_FAST_TIME_FORMAT",
            defaultValue: "M월 d일 a h시 m분"
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
    /// Fast Record & Weight Record Fomat
    static var yearMonthDayFormat: DateFormatter {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        return format
    }
    
    /// 2023년 10월
    static var yearMonthFormat: DateFormatter {
        let format = DateFormatter()
        format.dateFormat = Constants.Localization.YEAR_MONTH_FORMAT
        return format
    }
    
    static func toString(
        date: Date,
        format: DateFormatter
    ) -> String {
        return format.string(from: date)
    }
}
