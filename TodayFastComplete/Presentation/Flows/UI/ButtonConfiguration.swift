//
//  ButtonConfiguration.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/4/23.
//

import UIKit

extension UIButton.Configuration {
    static func imageCapsuleStyle(image: UIImage?) -> UIButton.Configuration {
        var configuration = UIButton.Configuration.filled()
        configuration.image = image
        configuration.cornerStyle = .capsule
        return configuration
    }
    static func titleCapsuleStyle(title: String) -> UIButton.Configuration {
        var configuration = UIButton.Configuration.filled()
        configuration.title = title
        configuration.attributedTitle = AttributedString(
            title,
            attributes: AttributeContainer([.font: UIFont.subtitleBold])
        )
        configuration.cornerStyle = .capsule
        return configuration
    }
}
