//
//  WeightRecordRepository.swift
//  TodayFastComplete
//
//  Created by JongHoon on 11/1/23.
//

import Foundation

import RxSwift

protocol WeightRecordRepository {
    func update(weightRecord: WeightRecord) -> Single<WeightRecord>
    func deleteWeightRecord(id: Date) -> Single<Date>
}
