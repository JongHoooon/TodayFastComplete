//
//  Localization.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/17/23.
//

// MARK: - Localization
extension Constants {
    enum Localization {
        static let TIMER_TITLE = String(
            localized: "TIMER_TITLE",
            defaultValue: "타이머"
        )
        static let RECORD_TITLE = String(
            localized: "RECORD_TITLE",
            defaultValue: "기록"
        )
        static let FAST_TITLE = String(
            localized: "FAST_TITLE",
            defaultValue: "단식"
        )
        static let WEIGHT_TITLE = String(
            localized: "WEIGHT_TITLE",
            defaultValue: "몸무게"
        )
        static let FAST_RECORD_TITLE = String(
            localized: "FAST_RECORD_TITLE",
            defaultValue: "단식 기록"
        )
        static let TOTAL_FAST_TIME_TITLE = String(
            localized: "TOTAL_FAST_TIME_TITLE",
            defaultValue: "총 단식 시간"
        )
        static let TOTAL_FAST_TIME = String(
            localized: "TOTAL_FAST_TIME",
            defaultValue: "%1$@ 시간 %2$@ 분"
        )
        static let FAST_TIME = String(
            localized: "FAST_TIME",
            defaultValue: "단식 시간"
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
        static let REMAIN_TIMER_TIME = String(
            localized: "REMAIN_TIMER_TIME",
            defaultValue: "남은 시간: %@"
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
        static let RECORD_EDIT = String(
            localized: "RECORD_EDIT",
            defaultValue: "기록 수정"
        )
        static let RECORD_DELETE = String(
            localized: "RECORD_DELETE",
            defaultValue: "기록 삭제"
        )
        
        static let YESTERDAY = String(
            localized: "YESTERDAY",
            defaultValue: "어제"
        )
        static let TODAY = String(
            localized: "TODAY",
            defaultValue: "오늘"
        )
        static let TOMORROW = String(
            localized: "TOMORROW",
            defaultValue: "내일"
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
        static let HOUR = String(
            localized: "HOUR",
            defaultValue: "시간"
        )
        static let MINUTE = String(
            localized: "MINUTE",
            defaultValue: "분"
        )
        
        static let START = String(
            localized: "START",
            defaultValue: "시작"
        )
        static let END = String(
            localized: "END",
            defaultValue: "종료"
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
}
