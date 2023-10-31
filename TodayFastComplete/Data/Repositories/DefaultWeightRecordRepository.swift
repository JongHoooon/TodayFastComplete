//
//  DefaultWeightRecordRepository.swift
//  TodayFastComplete
//
//  Created by JongHoon on 11/1/23.
//

import Foundation

import RealmSwift
import RxSwift

final class DefaultWeightRecordRepository: BaseRealmRepository, WeightRecordRepository {
    
    deinit {
        Log.deinit()
    }
    
    func update(weightRecord: WeightRecord) -> Single<WeightRecord> {
        return Single<WeightRecord>
            .create { [weak self] single in
                guard let self else { return Disposables.create() }
                let object = WeightRecordTable(
                    date: weightRecord.date,
                    weight: weightRecord.weight
                )
                do {
                    try realm.write {
                        self.realm.add(object, update: .modified)
                        single(.success(weightRecord))
                        Log.debug(weightRecord)
                    }
                } catch {
                    single(.failure(error))
                }
                return Disposables.create()
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(queue: realmTaskQueue))
    }
    
    func deleteWeightRecord(id: Date) -> Single<Date> {
        return Single<Date>
            .create { [weak self] single in
                guard let self else { return Disposables.create() }
                guard let object = realm.object(
                    ofType: WeightRecordTable.self,
                    forPrimaryKey: id.toString(format: .yearMonthDayFormat)
                ) else {
                    return Disposables.create()
                }
                do {
                    try realm.write {
                        self.realm.delete(object)
                        single(.success(id))
                        Log.debug(id)
                    }
                } catch {
                    single(.failure(error))
                }
                return Disposables.create()
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(queue: realmTaskQueue))
    }
}
