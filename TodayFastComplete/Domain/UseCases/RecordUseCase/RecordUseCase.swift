//
//  RecordUseCase.swift
//  TodayFastComplete
//
//  Created by JongHoon on 11/1/23.
//

import Foundation

import RxSwift

protocol RecordUseCase {
    func saveRecords(fastRecord: FastRecord, weightRecord: WeightRecord?) -> Single<(FastRecord, WeightRecord?)>
    func fetchFastRecords() -> Single<[FastRecord]>
    func fetchWeightRecords() -> Single<[WeightRecord]>
    func updateFastRecord(record: FastRecord) -> Single<FastRecord>
    func updateWeightRecord(record: WeightRecord) -> Single<WeightRecord>
    func deleteFastRecord(date: Date) -> Single<Date>
    func deleteWeightRecrod(date: Date) -> Single<Date>
}

final class RecordUseCaseImp: RecordUseCase {
    private let fastRecordRepository: FastRecordRepository
    private let weightRecordRepository: WeightRecordRepository
    
    init(
        fastRecordRepository: FastRecordRepository,
        weightRecordRepository: WeightRecordRepository
    ) {
        self.fastRecordRepository = fastRecordRepository
        self.weightRecordRepository = weightRecordRepository
    }
    
    deinit {
        Log.deinit()
    }
    
    func saveRecords(
        fastRecord: FastRecord,
        weightRecord: WeightRecord?
    ) -> Single<(FastRecord, WeightRecord?)> {
        var tasks = [
            fastRecordRepository.update(fastRecord: fastRecord).map { _ in }
        ]
        if let weightRecord {
            tasks.append(weightRecordRepository.update(weightRecord: weightRecord).map { _ in })
            UserDefaultsManager.recentSavedWeight = weightRecord.weight
        }
        return Single.zip(tasks)
            .map { _ in (fastRecord, weightRecord) }
    }
    
    func fetchFastRecords() -> Single<[FastRecord]> {
        return fastRecordRepository.fetchRecords()
    }
    
    func fetchWeightRecords() -> Single<[WeightRecord]> {
        return weightRecordRepository.fetchRecords()
    }
    
    func updateFastRecord(record: FastRecord) -> Single<FastRecord> {
        return fastRecordRepository.update(fastRecord: record)
    }
    
    func updateWeightRecord(record: WeightRecord) -> Single<WeightRecord> {
        return weightRecordRepository.update(weightRecord: record)
    }
    
    func deleteFastRecord(date: Date) -> Single<Date> {
        return fastRecordRepository.deleteFastRecord(id: date)
    }
    
    func deleteWeightRecrod(date: Date) -> Single<Date> {
        return weightRecordRepository.deleteWeightRecord(id: date)
    }
}
