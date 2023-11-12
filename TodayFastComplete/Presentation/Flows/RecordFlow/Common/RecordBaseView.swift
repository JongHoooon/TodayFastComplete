//
//  RecordBaseView.swift
//  TodayFastComplete
//
//  Created by JongHoon on 11/12/23.
//

import UIKit

final class RecordBaseView: UIView {
    
    init() {
        super.init(frame: .zero)
        configureView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension RecordBaseView {
    func configureView() {
        backgroundColor = .systemGray6
        layer.cornerRadius = 20.0
        layer.shadowColor = UIColor.black.cgColor
        layer.masksToBounds = false
        layer.shadowRadius = 4.0
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.2
    }
}
