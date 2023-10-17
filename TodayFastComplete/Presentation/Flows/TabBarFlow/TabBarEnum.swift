//
//  TabBarEnum.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/2/23.
//

import UIKit

enum TabBarEnum {
    case timer
    case record
    
    private var tabBarItem: UITabBarItem {
        switch self {
        case .timer:
            return UITabBarItem(
                title: Constants.Localization.TIMER_TITLE,
                image: Constants.Icon.timer,
                selectedImage: Constants.Icon.timer
            )
            
        case .record:
            return UITabBarItem(
                title: Constants.Localization.RECORD_TITLE,
                image: Constants.Icon.calendarBadgeClock,
                selectedImage: Constants.Icon.calendarBadgeClock
            )
        }
    }
    
    var rootNavigationController: UINavigationController {
        switch self {
        case .timer:
            let timerNavigationController = UINavigationController()
            timerNavigationController.tabBarItem = tabBarItem
            return timerNavigationController
        
        case .record:
            let recordNavigationController = UINavigationController()
            recordNavigationController.tabBarItem = tabBarItem
            return recordNavigationController
        }
    }
}
