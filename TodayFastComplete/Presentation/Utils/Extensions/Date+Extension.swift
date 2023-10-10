//
//  Date+Extension.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/10/23.
//

import Foundation

extension Date {
    var timeDateComponents: DateComponents {
        return Calendar.current.dateComponents([.hour, .minute], from: self)
    }
}
