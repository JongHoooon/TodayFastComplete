//
//  TimerViewController.swift
//  TodayFastComplete
//
//  Created by JongHoon on 9/30/23.
//

import UIKit

import RxSwift
import SnapKit

final class TimerViewController: BaseViewController {

    // MARK: - Properties
    private let viewModel: TimerViewModel
    private let disposeBag: DisposeBag
    
    // MARK: - UI
    private let fastTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .captionBold
        label.text = "루틴 모드"
        label.textColor = .systemGray
        return label
    }()
    private let fastInfoLabel: UILabel = {
        let label = UILabel()
        label.font = .captionRegural
        label.text = """
        단식 요일: 월, 화, 수, 목, 금
        단식 시간: 오후 07:00 ~ 오전 11:00 16시간
        식사 시간: 오전 11:00 ~ 오후 07:00 8시간
        """
        label.textAlignment = .center
        label.textColor = .systemGray
        label.numberOfLines = 0
        return label
    }()
    
    private let timerProgressView = TimerProgressView()
    
    private let timerInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8.0
        stackView.axis = .vertical
        stackView.alignment = .fill
        return stackView
    }()
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.text = "지방이 타고 있어요 🔥"
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    private let progressTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .custom(size: 48.0, weight: .bold)
        label.text = "00 : 03 : 32"
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    private let remainTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .subtitleBold
        label.text = "남은 시간: 15 : 56: 22"
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let todayStartTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .subtitleBold
        label.text = "‧ 시작: 09월 24일 19시 23분"
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    private let todayEndTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .subtitleBold
        label.text = "‧ 종료: 09월 25일 11시 23분"
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    private let todayStartTimeEditButton: UIButton = {
        let button = UIButton(configuration: .imageCapsuleStyle(image: Constants.Icon.pencilLine))
        button.configuration?.baseBackgroundColor = .systemGray5
        button.configuration?.image = Constants.Icon.pencilLine?.withTintColor(
            .systemGray2,
            renderingMode: .alwaysOriginal
        )
        return button
    }()
    
    private let fastControlButton: UIButton = {
        let button = UIButton(configuration: .titleCapsuleStyle(title: "단식 종료"))
        button.configuration?.baseBackgroundColor = Constants.Color.tintMain
        button.configuration?.baseForegroundColor = .label
        return button
    }()
    
    // MARK: - Lifecycle
    init(viewModel: TimerViewModel) {
        self.viewModel = viewModel
        self.disposeBag = DisposeBag()
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        Log.deinit()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var time = 0.0
        let timer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true,
            block: { [weak self] timer in
                if time == 1.0 { timer.invalidate() }
                time += 0.05
                self?.timerProgressView.progressValue = time
            })
        timer.fire()
    }
    
    // MARK: - Configure
    override func configure() {
        super.configure()
        bindViewModel()
    }
    
    override func configureNavigationBar() {
        navigationItem.title = Constants.Localization.TIMER_TITLE
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: Constants.Icon.gear,
            style: .plain,
            target: nil,
            action: nil
        )
    }
    
    override func configureLayout() {
        [
            messageLabel,
            progressTimeLabel,
            remainTimeLabel
        ].forEach { timerInfoStackView.addArrangedSubview($0) }
        
        [
            fastTitleLabel,
            fastInfoLabel,
            timerProgressView,
            timerInfoStackView,
            todayStartTimeLabel, todayStartTimeEditButton,
            todayEndTimeLabel,
            fastControlButton
        ].forEach { view.addSubview($0) }
        
        fastTitleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8.0)
            $0.centerX.equalToSuperview()
        }
        fastInfoLabel.snp.makeConstraints {
            $0.top.equalTo(fastTitleLabel.snp.bottom).offset(4.0)
            $0.centerX.equalToSuperview()
        }
        let progressViewHorizontalInset = 24.0
        timerProgressView.snp.makeConstraints {
            $0.top.equalTo(fastInfoLabel.snp.bottom).offset(36.0)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(progressViewHorizontalInset)
            $0.height.equalTo(timerProgressView.snp.width)
        }
        
        timerInfoStackView.snp.makeConstraints {
            $0.center.equalTo(timerProgressView)
        }
        
        let offset = (UIScreen.main.bounds.width - progressViewHorizontalInset * 2) / 4.0
        todayStartTimeLabel.snp.makeConstraints {
            $0.top.equalTo(timerProgressView.snp.bottom).offset(-offset + 32.0)
            $0.centerX.equalToSuperview()
        }
        todayEndTimeLabel.snp.makeConstraints {
            $0.top.equalTo(todayStartTimeLabel.snp.bottom).offset(16.0)
            $0.centerX.equalToSuperview()
        }
        todayStartTimeEditButton.snp.makeConstraints {
            $0.centerY.equalTo(todayStartTimeLabel)
            $0.leading.equalTo(todayStartTimeLabel.snp.trailing).offset(8.0)
            $0.width.equalTo(42.0)
        }
        
        fastControlButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(2.0 / 3.0)
            $0.height.equalTo(64.0)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-8.0)
        }
    }
}

private extension TimerViewController {
    func bindViewModel() {
        let input = TimerViewModel.Input(
            viewDidLoad: self.rx.viewDidLoad.asObservable(),
            viewWillAppear: self.rx.viewWillAppear.asObservable()
        )
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        output.fastTitle
            .asSignal()
            .emit(to: fastTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.fastInfoTitle
            .asSignal()
            .emit(to: fastInfoLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.messageText
            .asSignal()
            .emit(to: messageLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.progressTime
            .asSignal()
            .emit(to: progressTimeLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.remainTime
            .asSignal()
            .emit(to: remainTimeLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

struct KoreanViewControllerPreview: PreviewProvider {
    static var previews: some View {
        TimerViewController(viewModel: TimerViewModel())
            .showPreview()
            .environment(\.locale, .init(identifier: "ko"))
    }
}

struct EnglishViewControllerPreview: PreviewProvider {
    static var previews: some View {
        TimerViewController(viewModel: TimerViewModel())
            .showPreview()
            .previewDevice(PreviewDevice(rawValue: DeviceType.iPhone11Pro.name()))
            .environment(\.locale, .init(identifier: "en"))
    }
}
#endif
