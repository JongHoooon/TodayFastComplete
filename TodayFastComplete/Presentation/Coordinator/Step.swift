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
    case appFlowIsRequired(notificationType: LocalNotificationType? = nil)
    
    // Tab Bar
    case tabBarFlowIsRequired(tabBarIndex: Int)
    
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
    case writeRecordFlowIsRequired
    case writeFastRecord(startDate: Date, fastRecor: FastRecord? = nil, weightRecord: WeightRecord? = nil)
    case writeFastRecordIsComplete
    case writeRecordValidateAlert(title: String? = nil, message: String?)
    case recordDeleteAlert(
        record: RecordEnum,
        deleteAlertRelay: PublishRelay<AlertActionType>
    )
    
    // notification
    case fastStartNotification
    case fastEndNotification(startDate: Date)
}
