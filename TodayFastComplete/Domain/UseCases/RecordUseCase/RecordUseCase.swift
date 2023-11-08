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
}
