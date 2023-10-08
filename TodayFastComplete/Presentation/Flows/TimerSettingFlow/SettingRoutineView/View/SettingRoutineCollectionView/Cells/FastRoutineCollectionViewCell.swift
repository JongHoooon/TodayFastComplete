//
//  FastRoutineCollectionViewCell.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/6/23.
//

import UIKit

final class FastRoutineCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
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
    
    // MARK: - UI
    private let baseView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Color.disactive
        view.layer.cornerRadius = 8.0
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .custom(size: 24.0, weight: .bold)
        label.text = "16:8 단식"
        return label
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyRegural
        label.textColor = .systemGray
        label.text = "16 시간 동안 단식하고 \n8 시간 동안 식사하기"
        label.addLineSpacing(with: 4.0)
        label.numberOfLines = 0
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(routine: FastRoutine) {
        titleLabel.text = routine.routineTitle
        infoLabel.text = routine.routineInfo
        imageView.image = routine.image
    }
}

private extension FastRoutineCollectionViewCell {
    
    func configureLayout() {
        addSubview(baseView)
        [
            titleLabel,
            infoLabel,
            imageView
        ].forEach { baseView.addSubview($0) }
        
        baseView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(124.0)
        }
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16.0)
        }
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16.0)
            $0.leading.equalTo(titleLabel)
            $0.bottom.equalToSuperview().inset(16.0)
        }
        
        imageView.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview().inset(16.0)
            $0.leading.lessThanOrEqualTo(titleLabel.snp.trailing).offset(16.0)
            $0.width.equalTo(imageView.snp.height)
        }
    }
}
