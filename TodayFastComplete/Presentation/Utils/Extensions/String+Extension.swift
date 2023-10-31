//
//  String+Extension.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/31/23.
//

import Foundation

extension String {
    func toDate(formatter: DateFormatter) -> Date {
        let date = formatter.date(from: self) ?? Date()
        return date
    }
}
