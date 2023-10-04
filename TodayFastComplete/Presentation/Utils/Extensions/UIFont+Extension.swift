//
//  UIFont+Extension.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/4/23.
//

import UIKit

extension UIFont {
    // MARK: - Title
    static let titleBold = systemFont(ofSize: 30.0, weight: .bold)
    
    // MARK: - Subtitle
    static let subtitleBold = systemFont(ofSize: 20.0, weight: .bold)
    
    // MARK: - Body
    static let bodyBold = systemFont(ofSize: 16.0, weight: .bold)
    static let bodyMedium = systemFont(ofSize: 16.0, weight: .medium)
    static let bodyRegural = systemFont(ofSize: 16.0, weight: .regular)
    
    // MARK: - caption
    static let captionBold = systemFont(ofSize: 13.0, weight: .bold)
    static let captionMedium = systemFont(ofSize: 13.0, weight: .medium)
    static let captionRegural = systemFont(ofSize: 13.0, weight: .regular)
    
    // MARK: - Custom
    static func custom(size: CGFloat, weight: UIFont.Weight) -> UIFont {
        return systemFont(ofSize: size, weight: weight)
    }
}
