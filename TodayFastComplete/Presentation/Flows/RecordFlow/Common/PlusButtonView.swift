//
//  PlusButtonView.swift
//  TodayFastComplete
//
//  Created by JongHoon on 11/8/23.
//

import UIKit

final class PlusButtonView: UIView {

    private let plusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constants.Icon.plus
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label
        return imageView
    }()
    
    init() {
        super.init(frame: .zero)
        configure()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension PlusButtonView {
    func configure() {
        backgroundColor = .systemGray6
        configureLayer()
        configureLayout()
    }
    
    func configureLayer() {
        layer.cornerRadius = 20.0
        layer.shadowColor = UIColor.black.cgColor
        layer.masksToBounds = false
        layer.shadowRadius = 4.0
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.2
    }
    
    func configureLayout() {
        addSubview(plusImageView)
        plusImageView.snp.makeConstraints {
            $0.size.equalTo(self.snp.height).multipliedBy(0.3)
            $0.center.equalToSuperview()
        }
    }
}
