//
//  TitleCollectionViewHeader.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/6/23.
//

import UIKit

final class TitleCollectionViewHeader: UICollectionReusableView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "타이틀 라벨!"
        label.font = .subtitleBold
        return label
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

private extension TitleCollectionViewHeader {
    func configureLayout() {
        [
            titleLabel
        ].forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(16.0)
            $0.leading.equalToSuperview()
        }
    }
}
