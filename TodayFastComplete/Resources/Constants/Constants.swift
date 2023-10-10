//
//  Constants.swift
//  TodayFastComplete
//
//  Created by JongHoon on 9/30/23.
//

import UIKit

enum Constants { 
    
    // MARK: - Color
    enum Color {
        static let tintMain = UIColor(resource: .tintMain)
        static let tintBase = UIColor(resource: .tintBase)
        static let tintAccent = UIColor(resource: .tintAccent)
        static let tintAccentToBase = UIColor(resource: .tintAccentBase)
        static let tintBaeseToAccent = UIColor(resource: .tintBaseAccent)
        
        static let backgroundMain = UIColor(resource: .backgroundMain)
        
        static let disactive = UIColor.systemGray6
    }
    
    // MARK: - Icon
    enum Icon {
        static let gear = UIImage(systemName: "gearshape")
        static let info = UIImage(systemName: "info.circle.fill")
        static let pencilLine = UIImage(systemName: "pencil.line")
        static let plusCircle = UIImage(systemName: "plus.circle")
        static let timer = UIImage(systemName: "timer")
        static let xmark = UIImage(systemName: "xmark")
    }
    
    // MARK: - Image
    enum Imgage {
        static let fasting = UIImage(resource: .fasting)
        static let sandglass = UIImage(resource: .sandglass)
        static let timer = UIImage(resource: .timer)
    }
    
    // MARK: - Localization
    enum Localization {
        static let TIMER_TITLE = String(
            localized: "TIMER_TITLE",
            defaultValue: "타이머"
        )
        
        static let TIMER_MODE_SELECT_VIEW_TITLE = String(
            localized: "TIMER_MODE_SELECT_VIEW_TITLE",
            defaultValue: "타이머 모드 선택")
        static let ROUTINE_MODE_TITLE = String(
            localized: "ROUTINE_MODE_TITLE",
            defaultValue: "루틴 모드"
        )
        static let TIME_DESIGNATION_MODE_TITLE = String(
            localized: "TIME_DESIGNATION_MODE_TITLE",
            defaultValue: "시간 지정 모드"
        )
        
        static let SETTING_TIMER_TITLE = String(
            localized: "SETTING_TIMER_TITLE",
            defaultValue: "타이머 설정"
        )
        static let START_TIME_TEXTFIELD_PLACEHOLDER = String(
            localized: "START_TIME_TEXTFIELD_PLACEHOLDER",
            defaultValue: "🕐 단식을 언제 시작할까요?"
        )
        
        // 요일
        static let MONDAY = String(
            localized: "MONDAY",
            defaultValue: "월"
        )
        static let TUESDAY = String(
            localized: "TUESDAY",
            defaultValue: "화"
        )
        static let WEDNESDAY = String(
            localized: "WEDNESDAY",
            defaultValue: "수"
        )
        static let THURSDAY = String(
            localized: "THURSDAY",
            defaultValue: "목"
        )
        static let FRIDAY = String(
            localized: "FRIDAY",
            defaultValue: "금"
        )
        static let SATURDAY = String(
            localized: "SATURDAY",
            defaultValue: "토"
        )
        static let SUNDAY = String(
            localized: "SUNDAY",
            defaultValue: "일"
        )
        
        static let COMPLETE = String(
            localized: "COMPLETE",
            defaultValue: "완료"
        )
        static let SAVE = String(
            localized: "SAVE",
            defaultValue: "저장"
        )
        static let NEXT = String(
            localized: "NEXT",
            defaultValue: "다음"
        )
        static let CANCEL = String(
            localized: "CANCEL",
            defaultValue: "취소"
        )
    }
    
    enum DefaultValue {
        static let fastTimeIndex = 15
        static let fastTime = 16
        static var startTime = DateComponents(hour: 19, minute: 0)
        static var startTimeDate: Date {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            guard let date = formatter.date(from: "19:00") else { return Date() }
            return date
        }
    }
}
