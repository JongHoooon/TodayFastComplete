//
//  DefaultTimerRoutineSettingRepository.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/7/23.
//

import Foundation

import RealmSwift
import RxSwift

final class DefaultTimerRoutineSettingRepository: BaseRealmRepository, TimerRoutineSettingRepository {
    
    deinit {
        Log.deinit()
    }
    
    func update(routineSetting: TimerRoutineSetting) -> Single<TimerRoutineSetting> {
        return Single<TimerRoutineSetting>
            .create { [weak self] single in
                guard let self else { return Disposables.create() }
                guard let hour = routineSetting.startTime.hour,
                      let minute = routineSetting.startTime.minute
                else {
                    single(.failure(LocalRepositoryError.noData(message: "time component element")))
                    return Disposables.create()
                }
                let object = TimerRoutineSettingTable(
                    days: routineSetting.days.toList(),
                    startTimeHour: hour,
                    startTimeMinute: minute,
                    fastTime: routineSetting.fastTime
                )
                do {
                    try realm.write {
                        self.realm.add(object, update: .modified)
                        single(.success(object.toDomain()))
                    }
                } catch {
                    single(.failure(error))
                }
                return Disposables.create()
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(queue: realmTaskQueue))
    }
    
    func fetchRoutine() -> Single<TimerRoutineSetting?> {
        return Single<TimerRoutineSetting?>
            .create { [weak self] single in
                guard let self else { return Disposables.create() }
                let object = realm.object(ofType: TimerRoutineSettingTable.self, forPrimaryKey: RealmUniqueKey.fastRoutineSetting.rawValue)
                single(.success(object?.toDomain()))
                return Disposables.create()
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(queue: realmTaskQueue))
    }
    
    func deleteRoutine() -> Single<TimerRoutineSetting> {
        return Single<TimerRoutineSetting>
            .create { [weak self] single in
                guard let self else { return Disposables.create() }
                guard let object = realm.object(
                    ofType: TimerRoutineSettingTable.self,
                    forPrimaryKey: RealmUniqueKey.fastRoutineSetting.rawValue
                ) else {
                    return Disposables.create()
                }
                let timerRoutineSetting = object.toDomain()
                do {
                    try realm.write {
                        self.realm.delete(object)
                        single(.success(timerRoutineSetting))
                    }
                } catch {
                    single(.failure(error))
                }
                return Disposables.create()
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(queue: realmTaskQueue))
    }
}
