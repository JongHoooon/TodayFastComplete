//
//  FastTitleView.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/23/23.
//

import UIKit

enum FastTitleViewStyle {
    case start
    case end
    
    var title: String {
        switch self {
        case .start:
            return Constants.Localization.START
        case .end:
            return Constants.Localization.END
        }
    }
}

final class FastTitleView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        label.font = .bodyMedium
        label.text = "시작"
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .bodyMedium
        label.text = "10월 23일 오후 8:52"
        return label
    }()
    
    private let chevronDown = Constants.Icon.chevronDown?
        .withTintColor(.systemGray, renderingMode: .alwaysOriginal)
    
    private let chevronUp = Constants.Icon.chevronUp?
        .withTintColor(.systemGray, renderingMode: .alwaysOriginal)
    
    private let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constants.Icon.chevronDown?
            .withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        imageView.tintColor = .label
        return imageView
    }()
    
    init(style: FastTitleViewStyle) {
        super.init(frame: .zero)
        titleLabel.text = style.title
        configureLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var isDown = true
    func rotateChevronImage() {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.fromValue = isDown ? 0.0 : CGFloat.pi
        rotateAnimation.toValue = isDown ? CGFloat.pi : CGFloat.pi * 2.0
        rotateAnimation.duration = 0.2
        rotateAnimation.fillMode = .forwards
        rotateAnimation.isRemovedOnCompletion = false
        chevronImageView.layer.add(rotateAnimation, forKey: nil)
        isDown.toggle()
    }
}

private extension FastTitleView {
    func configureLayout() {
        [
            titleLabel,
            timeLabel,
            chevronImageView
        ].forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16.0)
            $0.centerY.equalToSuperview()
        }
        
        chevronImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(8.0)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(20.0)
        }
        
        timeLabel.snp.makeConstraints {
            $0.trailing.equalTo(chevronImageView.snp.leading).offset(-8.0)
            $0.centerY.equalToSuperview()
        }
    }
}
