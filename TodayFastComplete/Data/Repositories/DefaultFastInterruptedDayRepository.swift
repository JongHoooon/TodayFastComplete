//
//  DefaultFastInterruptedDayRepository.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/16/23.
//

import Foundation

import RealmSwift
import RxSwift

final class DefaultFastInterruptedDayRepository: BaseRealmRepository, FastInterruptedDayRepository {
    
    deinit {
        Log.deinit()
    }
    
    func update(
        interruptedFastDate: Date,
        interruptedFastEndDate: Date
    ) -> Single<InterruptedFast> {
        return Single.create { [weak self] single in
            guard let self else { return Disposables.create() }
            let object = FastInterruptedDayTable(
                uniqueKey: RealmUniqueKey.fastInterruptedDay.rawValue,
                interruptedDay: interruptedFastDate, 
                interruptedFastEndDate: interruptedFastEndDate
            )
            do {
                try realm.write {
                    self.realm.add(object, update: .modified)
                    single(.success(object.toDomain()))
                    Log.debug(object.toDomain())
                }
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: realmTaskQueue))
    }
    
    func fetchInterruptedDay() -> Single<InterruptedFast?> {
        return Single<InterruptedFast?>
            .create { [weak self] single in
                guard let self else { return Disposables.create() }
                let object = realm.object(
                    ofType: FastInterruptedDayTable.self,
                    forPrimaryKey: RealmUniqueKey.fastInterruptedDay.rawValue
                )
                single(.success(object?.toDomain()))
                Log.debug(object?.toDomain())
                return Disposables.create()
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(queue: realmTaskQueue))
    }
    
    func deleteInterruptedDay() -> Single<InterruptedFast> {
        return Single<InterruptedFast>
            .create { [weak self] single in
                guard let self else { return Disposables.create() }
                guard let object = realm.object(
                    ofType: FastInterruptedDayTable.self,
                    forPrimaryKey: RealmUniqueKey.fastInterruptedDay.rawValue
                ) else {
                    return Disposables.create()
                }
                let date = object.toDomain()
                do {
                    try realm.write {
                        self.realm.delete(object)
                        single(.success(date))
                        Log.debug(date)
                    }
                } catch {
                    single(.failure(error))
                }
                return Disposables.create()
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(queue: realmTaskQueue))
    }
}
