//
//  DeleteRoutineSettingCell.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/15/23.
//

import UIKit

final class DeleteRoutineSettingCell: UICollectionViewCell {
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.configuration = .titleCapsuleStyle(title: Constants.Localization.DELETE_FAST_ROUTINE_SETTING)
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
    
    func configureLayout() {
        contentView.addSubview(deleteButton)
        
        deleteButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(2.0 / 3.0)
            $0.height.equalTo(64.0)
            $0.top.bottom.equalToSuperview().inset(16.0)
        }
    }
}
