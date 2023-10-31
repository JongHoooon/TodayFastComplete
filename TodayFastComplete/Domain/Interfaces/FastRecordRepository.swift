//
//  FastRecordRepository.swift
//  TodayFastComplete
//
//  Created by JongHoon on 11/1/23.
//

import Foundation

import RxSwift

protocol FastRecordRepository {
    func update(fastRecord: FastRecord) -> Single<FastRecord>
    func deleteFastRecord(id: Date) -> Single<Date>
}
