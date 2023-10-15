//
//  TimeSettingCollectionViewCell.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/6/23.
//

import UIKit

import RxRelay

final class TimeSettingCollectionViewCell: UICollectionViewCell {
    
    private var isViewDidLoadCount = 0
    var timePickerViewTapped: PublishRelay<TimePickerViewType>?
 
    private let startTimeSettingView = TimeSettingView(kind: .startTime)
    private let fastTimeSettingView = TimeSettingView(kind: .fastTime)
    
    private let infoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = Constants.Icon.info?.withTintColor(
            Constants.Color.tintAccentToBase,
            renderingMode: .alwaysOriginal
        )
        return imageView
    }()
    
    private let infoTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .captionMedium
        label.textColor = .systemGray
        label.numberOfLines = 1
        label.text = String(localized: "FAST_INFO", defaultValue: "단식 정보")
        label.sizeToFit()
        return label
    }()
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = """
        단식 요일: 월, 화, 수, 목, 금
        단식 시간: 오후 07:00 ~ 오전 11:00 16시간
        식사 시간: 오전 11:00 ~ 오후 07:00 8시간
        """
        label.font = .captionRegural
        label.textColor = .systemGray
        label.numberOfLines = 0
        label.addLineSpacing(with: 2.0)
        label.textAlignment = .center
        // TODO: label 문구 수정 필요
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        addTapGesture()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureStartTimeLabel(with startTime: String) {
        startTimeSettingView.configureTimeLabelText(with: startTime)
        animateInfoImage()
    }
    
    func configureFastTimeLabel(with fastTime: String) {
        fastTimeSettingView.configureTimeLabelText(with: fastTime)
        animateInfoImage()
    }
    
    func configureSelectedFastInfoLabel(with info: String) {
        infoLabel.text = info
        infoLabel.addLineSpacing(with: 2.0)
        infoLabel.textAlignment = .center
    }
}

private extension TimeSettingCollectionViewCell {
    func configureLayout() {
        
        [
            startTimeSettingView,
            fastTimeSettingView,
            infoImageView, infoTitleLabel,
            infoLabel
        ].forEach { contentView.addSubview($0) }
        
        startTimeSettingView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(60.0)
        }
        fastTimeSettingView.snp.makeConstraints {
            $0.top.equalTo(startTimeSettingView.snp.bottom).offset(16.0)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(startTimeSettingView)
        }
        infoTitleLabel.snp.makeConstraints {
            $0.top.equalTo(fastTimeSettingView.snp.bottom).offset(16.0)
            $0.centerX.equalToSuperview()
        }
        infoImageView.snp.makeConstraints {
            $0.centerY.equalTo(infoTitleLabel)
            $0.size.equalTo(16.0)
            $0.trailing.equalTo(infoTitleLabel.snp.leading).offset(-2.0)
        }
        infoLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(infoImageView.snp.bottom).offset(4.0)
            $0.horizontalEdges.equalToSuperview().inset(16.0)
            $0.bottom.equalToSuperview()
        }
    }
    
    func addTapGesture() {
        let startTimeTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(startTimeViewTapped)
        )
        startTimeSettingView.addGestureRecognizer(startTimeTapGesture)
        let fastTimeTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(fastTimeViewTapped)
        )
        fastTimeSettingView.addGestureRecognizer(fastTimeTapGesture)
    }
    @objc
    func startTimeViewTapped() {
        timePickerViewTapped?.accept(.startTime)
    }
    @objc
    func fastTimeViewTapped() {
        timePickerViewTapped?.accept(.fastTime)
    }
    
    func animateInfoImage() {
        guard isViewDidLoadCount >= 2
        else {
            isViewDidLoadCount += 1
            return
        }
        if #available(iOS 17.0, *) {
            infoImageView.addSymbolEffect(.bounce.up.byLayer)
        } else {
            UIView.animate(
                withDuration: 0.15,
                delay: 0.0,
                options: .curveEaseOut,
                animations: { [weak self] in
                    self?.infoImageView.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
                },
                completion: { [weak self] _ in
                    UIView.animate(
                        withDuration: 0.1,
                        delay: 0.0,
                        options: .curveEaseOut,
                        animations: {
                            self?.infoImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        }
                )})
        }
    }
}
