//
//  TimerViewController.swift
//  TodayFastComplete
//
//  Created by JongHoon on 9/30/23.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class TimerViewController: BaseViewController {

    // MARK: - Properties
    private let viewModel: TimerViewModel
    private let disposeBag: DisposeBag
    
    // MARK: - UI
    private let fastInfoLabel: UILabel = {
        let label = UILabel()
        label.font = .captionRegural
        label.text = """
        단식 요일: 월, 화, 수, 목, 금
        단식 시간: 오후 07:00 ~ 오전 11:00 16시간
        식사 시간: 오전 11:00 ~ 오후 07:00 8시간
        """
        label.textColor = .systemGray
        label.numberOfLines = 3
        label.addLineSpacing(with: 2.0)
        label.textAlignment = .center
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
    
    private let selectFastModelBarButton = UIBarButtonItem(
        image: Constants.Icon.gear,
        style: .plain,
        target: nil,
        action: nil
    )
    
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
    }
    
    // MARK: - Configure
    override func configure() {
        super.configure()
        bindViewModel()
    }
    
    override func configureNavigationBar() {
        navigationItem.title = Constants.Localization.TIMER_TITLE
        navigationItem.rightBarButtonItem = selectFastModelBarButton
        navigationItem.backButtonTitle = ""
    }
    
    override func configureLayout() {
        [
            messageLabel,
            progressTimeLabel,
            remainTimeLabel
        ].forEach { timerInfoStackView.addArrangedSubview($0) }
        
        [
            fastInfoLabel,
            timerProgressView,
            timerInfoStackView,
            todayStartTimeLabel, todayStartTimeEditButton,
            todayEndTimeLabel,
            fastControlButton
        ].forEach { view.addSubview($0) }

        fastInfoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16.0)
            $0.height.equalTo(52.0)
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
            viewWillAppear: self.rx.viewWillAppear.asObservable(),
            selectFastModeButtonTapped: selectFastModelBarButton.rx.tap.asObservable()
        )
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        output.fastInfo
            .asDriver()
            .drive(fastInfoLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.messageText
            .asSignal()
            .emit(to: messageLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.progressTime
            .asDriver()
            .map { $0.timerString }
            .drive(progressTimeLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.remainTime
            .asDriver()
            .map { $0.timerString }
            .map { String(localized: "REMAIN_TIMER_TIME", defaultValue: "남은 시간: \($0)") }
            .drive(remainTimeLabel.rx.text)
            .disposed(by: disposeBag)
        
        let progressPercentDriver = output.progressPercent.asDriver()
        
        progressPercentDriver
            .drive(with: self, onNext: { owner, progress in
                owner.timerProgressView.progressValue = progress
                Log.debug(progress)
            })
            .disposed(by: disposeBag)
        
        progressPercentDriver
            .compactMap { Int($0 * 100) }
            .distinctUntilChanged()
            .drive { [weak self] in self?.timerProgressView.setProgressLabel(with: $0) }
            .disposed(by: disposeBag)
    }
}
