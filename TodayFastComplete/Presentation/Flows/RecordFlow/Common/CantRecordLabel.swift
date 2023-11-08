//
//  CantRecordLabel.swift
//  TodayFastComplete
//
//  Created by JongHoon on 11/9/23.
//

import UIKit

final class CantRecordLabel: UILabel {
    init() {
        super.init(frame: .zero)
        text = Constants.Localization.CANT_RECORD
        textColor = .systemGray
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
