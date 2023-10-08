//
//  DayCollectionViewCell.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/6/23.
//

import UIKit

final class DayCollectionViewCell: UICollectionViewCell {
    
    override var isSelected: Bool {
        didSet {
            switch isSelected {
            case true:
                baseView.backgroundColor = Constants.Color.tintBase
            case false:
                baseView.backgroundColor = Constants.Color.disactive
            }
        }
    }
    
    private let baseView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.label.cgColor
        view.backgroundColor = Constants.Color.disactive
        view.layer.cornerRadius = 8.0
        return view
    }()
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyRegural
        label.text = "월"
        label.textAlignment = .center
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
    
    func configureCell(with item: WeekDay) {
        dayLabel.text = item.weekDay
    }
}

private extension DayCollectionViewCell {
    func configureLayout() {
        baseView.addSubview(dayLabel)
        contentView.addSubview(baseView)
        
        baseView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(baseView.snp.width)
        }
        
        dayLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
