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
    static let hourMinuteFormat = {
        let format = DateFormatter()
        format.dateFormat = String(
            localized: "HOUR_MINUTE_FORMAT",
            defaultValue: "a h:mm"
        )
        return format
    }()
    
    static func toString(
        date: Date,
        format: DateFormatter
    ) -> String {
        return format.string(from: date)
    }
}
