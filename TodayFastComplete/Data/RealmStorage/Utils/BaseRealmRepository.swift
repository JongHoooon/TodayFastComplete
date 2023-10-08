//
//  BaseRealmRepository.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/8/23.
//

import Foundation

import RealmSwift

class BaseRealmRepository {
    var realm: Realm!
    let realmTaskQueue: DispatchQueue

    init() throws {
        realmTaskQueue = DispatchQueue(label: "realm_serial_queue")
        do {
            try realmTaskQueue.sync {
                realm = try Realm(
                    configuration: .defaultConfiguration,
                    queue: realmTaskQueue
                )
            }
            if let fileURL = realm.configuration.fileURL {
                Log.debug("Realm fileURL: \(fileURL)")
            }
        } catch {
            throw error
        }
    }
}
