//
//  List+Extension.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/7/23.
//

import RealmSwift

extension List {
    func toArray<T>() -> [T] {
        return self.compactMap { $0 as? T }
    }
}
