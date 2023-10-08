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
    
    func update(routineSetting: TimerRoutineSetting) -> Single<TimerRoutineSetting> {
        return Single<TimerRoutineSetting>
            .create { [weak self] single in
                guard let self else { return Disposables.create() }
                let object = TimerRoutineSettingTable(
                    days: routineSetting.days.toList(),
                    startTimeHour: routineSetting.startTime.hour,
                    startTimeMinute: routineSetting.startTime.minute,
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
    
    func fetch() -> Single<TimerRoutineSetting?> {
        return Single<TimerRoutineSetting?>
            .create { [weak self] single in
                guard let self else { return Disposables.create() }
                let object = realm.object(ofType: TimerRoutineSettingTable.self, forPrimaryKey: RealmUniqueKey.fastRoutine.rawValue)
                single(.success(object?.toDomain()))
                return Disposables.create()
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(queue: realmTaskQueue))
    }
}
