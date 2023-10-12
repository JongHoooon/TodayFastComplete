//
//  Int+Extension.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/12/23.
//

import Foundation

extension Int {
    var hour: Int {
        self / 3600
    }
    var minute: Int {
        (self % 3600) / 60
    }
    var second: Int {
        self % 60
    }
}
