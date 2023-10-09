//
//  Step.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/4/23.
//

import Foundation

import RxRelay

enum Step {
    // App
    case appFlowIsRequired
    
    // Tab Bar
    case tabBarFlowIsRequired
    
    // Timer
    case timerFlowIsRequired
    case timerSettingButtonTapped
    
    // Setting Timer
    case settingTimerFlowIsRequired
    case settingTimerFlowIsComplete
    case settingStartTimePickerViewTapped(selectedStartTime: PublishRelay<Date>)
    case settingStartTimePickerViewIsComplete
    
}
