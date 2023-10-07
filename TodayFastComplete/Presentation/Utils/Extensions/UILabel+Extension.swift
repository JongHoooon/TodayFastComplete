//
//  UILabel+Extension.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/7/23.
//

import UIKit

extension UILabel {
    func addLineSpacing(with spacing: CGFloat) {
        guard let text = text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = spacing
        attributedString.addAttribute(
            .paragraphStyle,
            value: style,
            range: NSRange(location: 0, length: attributedString.length)
        )
        attributedText = attributedString
    }
}
