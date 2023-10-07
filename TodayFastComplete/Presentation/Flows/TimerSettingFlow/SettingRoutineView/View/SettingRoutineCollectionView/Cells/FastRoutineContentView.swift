//
//  FastRoutineContentView.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/6/23.
//

import UIKit

final class FastRoutineContentView: UIView, UIContentView {
    
    private var currentConfiguration: FastRoutineContentConfiguration!
    var configuration: UIContentConfiguration {
        get {
            return currentConfiguration
        }
        set {
            guard let newConfiguration = newValue as? FastRoutineContentConfiguration else { return }
            apply(configuration: newConfiguration)
        }
    }
    
    private let baseView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Color.disactive
        view.layer.cornerRadius = 4.0
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
    
    init(configuration: FastRoutineContentConfiguration) {
        super.init(frame: .zero)
        self.configuration = configuration
        setupAllViews()
        apply(configuration: configuration)

    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension FastRoutineContentView {
    func setupAllViews() {
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
            $0.width.equalTo(imageView.snp.height)
        }
    }
    
    func apply(configuration: FastRoutineContentConfiguration) {
        guard currentConfiguration != configuration else { return }
        
        currentConfiguration = configuration
        titleLabel.text = configuration.title
        infoLabel.text = configuration.info
        baseView.backgroundColor = configuration.backgroundColor
        imageView.image = configuration.image
    }
}

struct FastRoutineContentConfiguration: UIContentConfiguration, Hashable {
    var backgroundColor: UIColor?
    var title: String?
    var info: String?
    var image: UIImage?
    
    func makeContentView() -> UIView & UIContentView {
        return FastRoutineContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> FastRoutineContentConfiguration {
        guard let state = state as? UICellConfigurationState else { return self }
        var updatedConfiguraion = self
        switch state.isSelected {
        case true:
            updatedConfiguraion.backgroundColor = Constants.Color.tintBase
        case false:
            updatedConfiguraion.backgroundColor = Constants.Color.disactive
        }
        
        return updatedConfiguraion
    }
}
