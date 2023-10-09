//
//  FastMode.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/5/23.
//

import UIKit

enum FastMode: Int, CaseIterable {
    case routine
    case timeDesignation
    
    var title: String {
        switch self {
        case .routine:
            return Constants.Localization.ROUTINE_MODE_TITLE
        case .timeDesignation:
            return Constants.Localization.TIME_DESIGNATION_MODE_TITLE
        }
    }
    
    var image: UIImage {
        switch self {
        case .routine:
            return Constants.Imgage.timer
        case .timeDesignation:
            return Constants.Imgage.sandglass
        }
    }
    
    var explanation: String {
        switch self {
        case .routine:
            return "루틴 모드 설명입니다.루틴 모드 설명입니다.루틴 모드 설명입니다.루틴 모드 설명입니다.루틴 모드 설명입니다.루틴 모드 설명입니다.루틴 모드 설명입니다.루틴 모드 설명입니다.루틴 모드 설명입니다.루틴 모드 설명입니다.루틴 모드 설명입니다.루틴 모드 설명입니다.루틴 모드 설명입니다.루틴 모드 설명입니다.루틴 모드 설명입니다."
        case .timeDesignation:
            return "시간 지정 보드 설명입니다.시간 지정 보드 설명입니다.시간 지정 보드 설명입니다.시간 지정 보드 설명입니다.시간 지정 보드 설명입니다.시간 지정 보드 설명입니다.시간 지정 보드 설명입니다.시간 지정 보드 설명입니다.시간 지정 보드 설명입니다.시간 지정 보드 설명입니다.시간 지정 보드 설명입니다.시간 지정 보드 설명입니다.시간 지정 보드 설명입니다.시간 지정 보드 설명입니다.시간 지정 보드 설명입니다.시간 지정 보드 설명입니다.시간 지정 보드 설명입니다."
        }
    }
}
