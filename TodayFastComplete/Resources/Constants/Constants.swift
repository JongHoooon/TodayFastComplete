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
        static let TIMER_VIEW_FAST_INFO = String(
            localized: "TIMER_VIEW_FAST_INFO",
            defaultValue: """
            단식 요일: %1$@
            단식 시간: %2$@ - %3$@ %4$lld시간
            식사 시간: %5$@ - %6$@ %7$lld시간
            """
        )
        static let PLEASE_SELECT_WEEKDAYS = String(
            localized: "PLEASE_SELECT_WEEKDAYS",
            defaultValue: "(단식 요일을 선택해 주세요.)"
        )
        static let FINISH_FAST = String(
            localized: "FINISH_FAST",
            defaultValue: "단식 종료"
        )
        static let DELETE_FAST_ROUTINE_SETTING = String(
            localized: "DELETE_ROUTINE_SETTING",
            defaultValue: "타이머 설정 삭제"
        )
        static let DELETE_FAST_ALERT_MESSAGE = String(
            localized: "DELETE_FAST_ALERT_MESSAGE",
            defaultValue: "타이머 설정을 삭제할까요?"
        )
        static let DO_DELETE = String(
            localized: "DO_DELETE",
            defaultValue: "삭제하기"
        )
        static let FINISH_FAST_ALERT_MESSAGE = String(
            localized: "FINISH_FAST_ALERT_MESSAGE",
            defaultValue: "정말로 단식을 종료할까요?"
        )
        static let DO_FINISH = String(
            localized: "DO_FINISH",
            defaultValue: "종료하기"
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
        static let CONFIRM = String(
            localized: "CONFIRM",
            defaultValue: "확인"
        )
        static let CANCEL = String(
            localized: "CANCEL",
            defaultValue: "취소"
        )
    }
    
    enum DefaultValue {
        static let fastTimeIndex = 15
        static let fastTime = 15
        static var startTime = DateComponents(hour: 19, minute: 0)
        static var startTimeDate: Date {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            guard let date = formatter.date(from: "19:00") else { return Date() }
            return date
        }
        static var timerDateComponents = DateComponents(hour: 0, minute: 0, second: 0)
        static var localNotificationMaxCount = 64
    }
}
