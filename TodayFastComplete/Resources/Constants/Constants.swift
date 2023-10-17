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
