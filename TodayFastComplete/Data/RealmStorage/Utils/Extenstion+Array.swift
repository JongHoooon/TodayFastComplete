//
//  Extenstion+Array.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/7/23.
//

import RealmSwift

extension Array {
    func toList<T>() -> List<T> {
        let list = List<T>()
        self.forEach {
            if let element = $0 as? T {
                list.append(element)
            }
        }
        return list
    }
}
