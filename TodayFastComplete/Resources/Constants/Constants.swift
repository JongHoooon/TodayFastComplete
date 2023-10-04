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
    }
    
    // MARK: - Localization
    enum Localization {
        static let TIMER_TITLE = String(localized: "TIMER_TITLE", defaultValue: "타이머")
    }
}
