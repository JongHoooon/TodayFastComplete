//
//  StartTimeCollectionViewCell.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/6/23.
//

import UIKit

final class StartTimeCollectionViewCell: UICollectionViewCell {
 
    private let textField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(
            string: Constants.Localization.START_TIME_TEXTFIELD_PLACEHOLDER,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray]
        )
        textField.font = .bodyMedium
        textField.backgroundColor = Constants.Color.disactive
        textField.layer.cornerRadius = 4.0
        textField.addHorizontalPadding(with: 16.0)
        textField.isEnabled = false
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension StartTimeCollectionViewCell {
    func configureLayout() {
        contentView.addSubview(textField)
    
        textField.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(60.0)
        }
    }
}
