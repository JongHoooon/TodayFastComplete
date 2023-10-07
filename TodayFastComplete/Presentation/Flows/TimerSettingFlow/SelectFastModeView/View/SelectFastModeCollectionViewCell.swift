//
//  SelectFastModeCollectionViewCell.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/5/23.
//

import UIKit

final class SelectFastModeCollectionViewCell: UICollectionViewCell {
    
    override var isSelected: Bool {
        didSet {
            switch isSelected {
            case true:
                baseView.backgroundColor = Constants.Color.tintMain
            case false:
                baseView.backgroundColor = Constants.Color.disactive
            }
        }
    }
    
    // MARK: - UI
    private let baseView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Color.disactive
        view.layer.cornerRadius = 24.0
        return view
    }()
    
    private let contentsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .clear
        stackView.spacing = 16.0
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private let modeLabel: UILabel = {
        let label = UILabel()
        label.font = .subtitleBold
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        configureLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(mode: FastMode) {
        imageView.image = mode.image
        modeLabel.text = mode.title
    }
}

private extension SelectFastModeCollectionViewCell {
    
    func configureLayout() {
        [
            imageView,
            modeLabel
        ].forEach { contentsStackView.addArrangedSubview($0) }
        baseView.addSubview(contentsStackView)
        contentView.addSubview(baseView)
        
        contentsStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        baseView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints {
            $0.size.equalTo(contentView.snp.width).multipliedBy(0.5)
        }
    }
}
