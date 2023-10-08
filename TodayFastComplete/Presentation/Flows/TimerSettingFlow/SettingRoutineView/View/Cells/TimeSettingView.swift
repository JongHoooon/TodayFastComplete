//
//  TimeSettingView.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/8/23.
//

import UIKit

final class TimeSettingView: UIView {
    
    enum TimeSettingViewKind {
        case startTime
        case fastTime
        
        var title: String {
            switch self {
            case .startTime:
                return String(localized: "START_TIME_TITLE", defaultValue: "시작 시간 ⏰")
            case .fastTime:
                return String(localized: "FAST_TIME_TITLE", defaultValue: "단식 시간 🤐")
            }
        }
    }
    
    // MARK: - Properties
    private let kind: TimeSettingViewKind
    
    // MARK: - UI
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyMedium
        label.textColor = .systemGray
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyMedium
        label.textColor = .label
        label.text = "17시간"
        return label
    }()
    
    init(kind: TimeSettingViewKind) {
        self.kind = kind
        titleLabel.text = kind.title
        super.init(frame: .zero)
        backgroundColor = Constants.Color.disactive
        layer.cornerRadius = 8.0
        configureLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureTimeLabelText(with text: String) {
        timeLabel.text = text
    }
}

private extension TimeSettingView {
    func configureLayout() {
        [
            titleLabel,
            timeLabel
        ].forEach {
            addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16.0)
            $0.centerY.equalToSuperview()
        }
        timeLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16.0)
            $0.centerY.equalToSuperview()
        }
    }
}
