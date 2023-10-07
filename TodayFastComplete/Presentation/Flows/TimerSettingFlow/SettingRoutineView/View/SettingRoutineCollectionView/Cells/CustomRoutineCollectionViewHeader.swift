//
//  CustomRoutineCollectionViewHeader.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/7/23.
//

import UIKit

final class CustomRoutineCollectionViewHeader: UICollectionReusableView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "타이틀 라벨!"
        label.font = .subtitleBold
        return label
    }()
    
    private let plusButton: UIButton = {
        let button = UIButton()
        button.setImage(
            Constants.Icon.plusCircle?.withTintColor(.label, renderingMode: .alwaysOriginal),
            for: .normal
        )
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with title: String) {
        titleLabel.text = title
    }
}

private extension CustomRoutineCollectionViewHeader {
    func configureLayout() {
        [
            titleLabel,
            plusButton
        ].forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(16.0)
            $0.leading.equalToSuperview()
        }
        plusButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.size.equalTo(32.0)
            $0.trailing.equalToSuperview()
        }
        plusButton.imageView?.snp.makeConstraints {
            $0.edges.equalTo(plusButton)
        }
    }
}
