//
//  DateComponents+Extension.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/10/23.
//

import CoreFoundation
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
    
    var timerString: String {
        let calendar = Calendar.current
        guard let date = calendar.date(from: self)
        else { 
            return "00 : 00 : 00"
        }
        return DateFormatter.toString(date: date, format: .timerHourMinuteSecondFormat)
    }
    
    /// 같은 날의 시간, 분, 초 비교시 사용
    func timeCompare(with dateComponents: DateComponents) -> ComparisonResult {
        let time = timeToSecond(with: self)
        let compareTime = timeToSecond(with: dateComponents)
        
        if time == compareTime {
            return .orderedSame
        } else if time < compareTime {
            return .orderedAscending
        } else {
            return .orderedDescending
        }
    }
    
    /// 시, 분, 초 값을 초 단위로 변환 합니다.
    func timeToSecond(with dateComponents: DateComponents) -> Int {
        let hour = dateComponents.hour ?? 0
        let minute = dateComponents.minute ?? 0
        let second = dateComponents.second ?? 0
        return hour * 3600 + minute * 60 + second
    }
}
