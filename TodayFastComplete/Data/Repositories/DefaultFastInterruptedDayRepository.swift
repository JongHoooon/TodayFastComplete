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
    
    func update(interruptedDay: Date) -> Single<Date> {
        return Single.create { [weak self] single in
            guard let self else { return Disposables.create() }
            let object = FastInterruptedDayTable(
                uniqueKey: RealmUniqueKey.fastInterruptedDay.rawValue,
                interruptedDay: interruptedDay
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
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
    }
    
    func fetchInterruptedDay() -> Single<Date?> {
        return Single<Date?>
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
            .subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
    }
    
    func deleteInterruptedDay() -> Single<Date> {
        return Single<Date>
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
            .subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
    }
}
