//
//  Reuseable.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/5/23.
//

import UIKit

protocol Reusable {}

extension Reusable {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionReusableView: Reusable {}
