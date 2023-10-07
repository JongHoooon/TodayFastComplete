//
//  UITextField+Extension.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/7/23.
//

import UIKit

extension UITextField {
    
    /// 좌,우 패딩 추가
    func addHorizontalPadding(with padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(
            x: 0,
            y: 0,
            width: padding,
            height: self.frame.height
        ))
        leftView = paddingView
        rightView = paddingView
        leftViewMode = .always
        rightViewMode = .always
    }
}
