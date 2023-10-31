//
//  DefaultFastRecordRepository.swift
//  TodayFastComplete
//
//  Created by JongHoon on 11/1/23.
//

import Foundation

import RealmSwift
import RxSwift

final class DefaultFastRecordRepository: BaseRealmRepository, FastRecordRepository {
    
    deinit {
        Log.deinit()
    }
    
    func update(fastRecord: FastRecord) -> RxSwift.Single<FastRecord> {
        return Single<FastRecord>
            .create { [weak self] single in
                guard let self else { return Disposables.create() }
                let object = FastRecordTable(
                    date: fastRecord.date,
                    startDate: fastRecord.startDate,
                    endDate: fastRecord.endDate
                )
                do {
                    try realm.write {
                        self.realm.add(object, update: .modified)
                        single(.success(fastRecord))
                        Log.debug(fastRecord)
                    }
                } catch {
                    single(.failure(error))
                }
                return Disposables.create()
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(queue: realmTaskQueue))
    }
    
    func deleteFastRecord(id: Date) -> RxSwift.Single<Date> {
        return Single<Date>
            .create { [weak self] single in
                guard let self else { return Disposables.create() }
                guard let object = realm.object(
                    ofType: FastRecordTable.self,
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
