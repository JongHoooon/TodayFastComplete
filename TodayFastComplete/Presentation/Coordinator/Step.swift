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
    case settingStartTimePickerViewTapped(
        selectedStartTime: BehaviorRelay<Date>,
        initialStartTime: Date
    )
    case settingStartTimePickerViewIsComplete
    case settingFastTimePickerViewTapped(
        selectedFastTime: BehaviorRelay<Int>,
        recommendSectionNeedDeselect: PublishRelay<Void>,
        initialFastTime: Int
    )
    case settingFastTimePickerViewIsComplete
    
}
