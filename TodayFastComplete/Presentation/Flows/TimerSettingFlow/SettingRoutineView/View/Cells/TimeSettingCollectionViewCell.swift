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
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = .captionRegural
        label.textColor = .systemGray
        label.addLineSpacing(with: 2.0)
        label.numberOfLines = 0
        label.textAlignment = .left
        // TODO: label 문구 수정 필요
        label.text = """
        시간 시간과 단식 시간을 입력해주세요!!
        인포 라벨입니다! 단식 루틴에대해 설명해줌, 인포 라벨입니다! 단식 루틴에대해 설명해줌, 인포 라벨입니다! 단식 루틴에대해 설명해줌인포 라벨입니다! 단식 루틴에대해 설명해줌인포 라벨입니다! 설명해줌인포 라벨입니다! 단식 루틴에대해 설명해줌인포 라벨입니다!설명해줌인포 라벨입니다! 단식 루틴에대해 설명해줌인포 라벨입니다!
        """
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
}

private extension TimeSettingCollectionViewCell {
    func configureLayout() {
        
        [
            startTimeSettingView,
            fastTimeSettingView,
            infoImageView, infoLabel
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
        infoImageView.snp.makeConstraints {
            $0.top.equalTo(fastTimeSettingView.snp.bottom).offset(8.0)
            $0.size.equalTo(16.0)
            $0.leading.equalToSuperview()
        }
        infoLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(infoImageView)
            $0.leading.equalTo(infoImageView.snp.trailing).offset(4.0)
            $0.trailing.equalToSuperview()
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
                options: .curveEaseIn,
                animations: { [weak self] in
                    self?.infoImageView.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
                },
                completion: { [weak self] _ in
                    UIView.animate(
                        withDuration: 0.1,
                        delay: 0.0,
                        options: .curveEaseIn,
                        animations: {
                            self?.infoImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        }
                )})
        }
    }
}
