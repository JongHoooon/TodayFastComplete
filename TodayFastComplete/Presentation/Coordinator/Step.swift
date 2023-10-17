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
    case timerSettingButtonTapped(
        currentRoutineSetting: BehaviorRelay<TimerRoutineSetting?>,
        interruptedFast: BehaviorRelay<InterruptedFast?>
    )
    case timerInterruptFastButtonTapped(interruptFastAlertRelay: PublishRelay<AlertActionType>)
    
    // Setting Timer
    case settingTimerFlowIsRequired(
        currentRoutineSetting: BehaviorRelay<TimerRoutineSetting?>,
        interruptedFast: BehaviorRelay<InterruptedFast?>
    )
    case settingTimerFlowIsComplete
    case settingStartTimePickerViewTapped(
        selectedStartTime: BehaviorRelay<DateComponents>,
        initialStartTime: DateComponents
    )
    case settingStartTimePickerViewIsComplete
    case settingFastTimePickerViewTapped(
        selectedFastTime: BehaviorRelay<Int>,
        recommendSectionNeedDeselect: PublishRelay<Void>,
        initialFastTime: Int
    )
    case settingFastTimePickerViewIsComplete
    case settingDeleteRoutineSettingButtonTapped(deleteAlertActionRelay: PublishRelay<AlertActionType>)
    
    // Record
    case recordFlowIsRequired
}
