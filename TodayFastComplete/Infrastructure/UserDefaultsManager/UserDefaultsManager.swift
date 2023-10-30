//
//  UserDefaultsManager.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/20/23.
//

import Foundation

import RxSwift

enum UserDefaultsManager {
    
    @propertyWrapper
    struct UserDefault<T> {
        private let key: String
        private let defaultValue: T
        
        init(
            key: UserDefaultsKey,
            defaultValue: T
        ) {
            self.key = key.rawValue
            self.defaultValue = defaultValue
        }
        
        var wrappedValue: T {
            get { UserDefaults.standard.object(forKey: key) as? T ?? defaultValue }
            set { UserDefaults.standard.set(newValue, forKey: key) }
        }
    }
        
    enum UserDefaultsKey: String, CaseIterable {
        case notificationHandled
        case routineSetting
    }
    
    @UserDefault(key: .notificationHandled, defaultValue: false)
    static var notificationHandled: Bool
    
    static func save(routineSetting: TimerRoutineSetting) -> Single<TimerRoutineSetting> {
        return Single<TimerRoutineSetting>
            .create { single in
                let encoder = JSONEncoder()
                do {
                    let data = try encoder.encode(routineSetting)
                    UserDefaults.standard.setValue(data, forKey: UserDefaultsKey.routineSetting.rawValue)
                    single(.success(routineSetting))
                } catch {
                    single(.failure(error))
                    Log.error(error)
                }
                return Disposables.create()
            }
    }
    
    static var routineSetting: TimerRoutineSetting? {
        let decoder = JSONDecoder()
        guard let data = UserDefaults.standard.object(forKey: UserDefaultsKey.routineSetting.rawValue) as? Data
        else {
            return nil
        }
        guard let routineSetting = try? decoder.decode(TimerRoutineSetting.self, from: data)
        else {
            return nil
        }
        return routineSetting
    }
}
