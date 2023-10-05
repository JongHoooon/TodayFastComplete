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
        
        static let backgroundMain = UIColor(resource: .backgroundMain)
    }
    
    // MARK: - Icon
    enum Icon {
        static let timer = UIImage(systemName: "timer")
        static let pencilLine = UIImage(systemName: "pencil.line")
        static let gear = UIImage(systemName: "gearshape")
        static let xmark = UIImage(systemName: "xmark")
    }
    
    // MARK: - Image
    enum Imgage {
        static let sandglass = UIImage(resource: .sandglass)
        static let timer = UIImage(resource: .timer)
    }
    
    // MARK: - Localization
    enum Localization {
        static let TIMER_TITLE = String(
            localized: "TIMER_TITLE",
            defaultValue: "타이머"
        )
        
        static let ROUTINE_MODE_TITLE = String(
            localized: "ROUTINE_MODE_TITLE",
            defaultValue: "루틴 모드"
        )
        static let TIME_DESIGNATION_MODE_TITLE = String(
            localized: "TIME_DESIGNATION_MODE_TITLE",
            defaultValue: "시간 지정 모드"
        )
    }
}
