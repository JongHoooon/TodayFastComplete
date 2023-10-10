//
//  DateComponents+Extension.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/10/23.
//

import Foundation

extension DateComponents {
    func toDate() -> Date {
        return Calendar.current.date(from: self) ?? Constants.DefaultValue.startTimeDate
    }
    
    
    var timeString: String {
        let calendar = Calendar.current
        let date = calendar.date(from: self) ?? Constants.DefaultValue.startTimeDate
        return DateFormatter.toString(date: date, format: .hourMinuteFormat)
    }
}
