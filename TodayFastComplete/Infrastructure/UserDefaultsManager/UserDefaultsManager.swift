//
//  UserDefaultsManager.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/20/23.
//

import Foundation

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
    }
    
    @UserDefault(key: .notificationHandled, defaultValue: false)
    static var notificationHandled: Bool
}
