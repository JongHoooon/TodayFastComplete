//
//  LocalNotificationRepository.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/14/23.
//

import RxSwift

protocol LocalNotificationRepository {
    func updateFastIDs(ids: [String]) -> Single<[String]>
    func deleteAllFastIDs() -> Completable
}
