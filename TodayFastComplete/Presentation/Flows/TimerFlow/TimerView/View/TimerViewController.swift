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
    
    private let currentLoopStartLabel: UILabel = {
        let label = UILabel()
        label.font = .subtitleBold
        label.text = "‧ 시작: 09월 24일 19시 23분"
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    private let currentLoopEndLabel: UILabel = {
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
        button.isHidden = true
        return button
    }()
    
    private let fastControlButton: UIButton = {
        let button = UIButton(configuration: .titleCapsuleStyle(title: "단식 종료"))
        button.configuration?.baseBackgroundColor = Constants.Color.tintMain
        button.configuration?.baseForegroundColor = .label
        return button
    }()
    
    private let setTimerButton = UIBarButtonItem(
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
        navigationItem.rightBarButtonItem = setTimerButton
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
            currentLoopStartLabel, todayStartTimeEditButton,
            currentLoopEndLabel,
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
        currentLoopStartLabel.snp.makeConstraints {
            $0.top.equalTo(timerProgressView.snp.bottom).offset(-offset + 32.0)
            $0.centerX.equalToSuperview()
        }
        currentLoopEndLabel.snp.makeConstraints {
            $0.top.equalTo(currentLoopStartLabel.snp.bottom).offset(16.0)
            $0.centerX.equalToSuperview()
        }
        todayStartTimeEditButton.snp.makeConstraints {
            $0.centerY.equalTo(currentLoopStartLabel)
            $0.leading.equalTo(currentLoopStartLabel.snp.trailing).offset(8.0)
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
        
        let progressViewEndpoinButtonTapped = timerProgressView.endPointButton.rx.tap
            .do(onNext: { _ in UIImpactFeedbackGenerator(style: .soft).impactOccurred() })
            .asObservable()
        
        let input = TimerViewModel.Input(
            viewDidLoad: self.rx.viewDidLoad.asObservable(),
            viewWillAppear: self.rx.viewWillAppear.asObservable(),
            viewDidDisappear: self.rx.viewDidDisappear.asObservable(),
            progressViewEndpoinButtonTapped: progressViewEndpoinButtonTapped,
            setTimerButtonTapped: setTimerButton.rx.tap.asObservable()
        )
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        output.fastInfo
            .asDriver()
            .distinctUntilChanged()
            .drive(fastInfoLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.messageText
            .asSignal()
            .distinctUntilChanged()
            .emit(to: messageLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.progressTime
            .asDriver()
            .map { $0.timerString }
            .drive(progressTimeLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.remainTimeLabelIsHiddend
            .asDriver()
            .drive(remainTimeLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.remainTime
            .asDriver()
            .map { $0.timerString }
            .map { [weak self] in
                switch self?.viewModel.timerState.value {
                case .fastTime:
                    return String(localized: "REMAIN_TIMER_TIME", defaultValue: "남은 시간: \($0)")
                case .mealTime:
                    return String(localized: "REMAIN_MEAL_TIME", defaultValue: "다음 단식 까지: \($0)")
                default:
                    return $0
                }
            }
            .drive(remainTimeLabel.rx.text)
            .disposed(by: disposeBag)
        
        let progressPercentDriver = output.progressPercent.asDriver()
        progressPercentDriver
            .drive(with: self, onNext: { owner, progress in
                owner.timerProgressView.progressValue = progress
//                Log.debug(progress)
            })
            .disposed(by: disposeBag)
        progressPercentDriver
            .compactMap { Int($0 * 100) }
            .distinctUntilChanged()
            .drive { [weak self] in self?.timerProgressView.setEndPointTitle(with: $0) }
            .disposed(by: disposeBag)
        
        output.currentLoopTimeLabelIsHidden
            .asDriver()
            .distinctUntilChanged()
            .drive(currentLoopStartLabel.rx.isHidden, currentLoopEndLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.currentLoopStartTime
            .asDriver()
            .distinctUntilChanged()
            .map {
                String(localized: "START", defaultValue: "‧ 시작: ")
                    + $0.toString(format: .currentFastTimeFormat)
            }
            .drive(currentLoopStartLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.endpointButtonTitle
            .asDriver()
            .distinctUntilChanged()
            .drive(timerProgressView.endPointButton.rx.title())
            .disposed(by: disposeBag)
        
        output.currentLoopEndTime
            .asDriver()
            .distinctUntilChanged()
            .map {
                String(localized: "END", defaultValue: "‧ 종료: ")
                    + $0.toString(format: .currentFastTimeFormat)
            }
            .drive(currentLoopEndLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.fastControlButtonIsEnabled
            .asDriver()
            .distinctUntilChanged()
            .drive(fastControlButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}
