//
//  FastInterruptable.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/16/23.
//

import Foundation

import RxSwift

protocol FastInterruptable {
    func interruptFast(currentFastEndDate: Date, interruptedDate: Date) -> Single<InterruptedFast>
    func fetchInterruptedFastDate() -> Single<InterruptedFast?>
}
