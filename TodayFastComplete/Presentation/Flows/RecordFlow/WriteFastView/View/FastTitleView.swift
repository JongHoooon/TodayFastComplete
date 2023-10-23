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
    
    private let pencilImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Constants.Icon.pencilLine
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
}

private extension FastTitleView {
    func configureLayout() {
        [
            titleLabel,
            timeLabel,
            pencilImageView
        ].forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16.0)
            $0.centerY.equalToSuperview()
        }
        
        pencilImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16.0)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(20.0)
        }
        
        timeLabel.snp.makeConstraints {
            $0.trailing.equalTo(pencilImageView.snp.leading).offset(-4.0)
            $0.centerY.equalToSuperview()
        }
    }
}
