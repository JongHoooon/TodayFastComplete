//
//  FastInterruptedDayRepository.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/16/23.
//

import Foundation

import RxSwift

protocol FastInterruptedDayRepository {
    func update(interruptedDay: Date) -> Single<Date>
    func fetchInterruptedDay() -> Single<Date?>
    func deleteInterruptedDay() -> Single<Date>
}
