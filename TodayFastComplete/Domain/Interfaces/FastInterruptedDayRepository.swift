//
//  FastInterruptedDayRepository.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/16/23.
//

import Foundation

import RxSwift

protocol FastInterruptedDayRepository {
    func update(interruptedFastDate: Date, interruptedFastEndDate: Date) -> Single<InterruptedFast>
    func fetchInterruptedDay() -> Single<InterruptedFast?>
    func deleteInterruptedDay() -> Single<InterruptedFast>
}
