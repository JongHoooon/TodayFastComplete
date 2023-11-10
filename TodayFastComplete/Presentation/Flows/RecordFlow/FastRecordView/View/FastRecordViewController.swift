//
//  FastRecordViewController.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/18/23.
//

import UIKit

import RxCocoa
import RxSwift

final class FastRecordViewController: BaseViewController {
    
    // MARK: - Properties
    private let viewModel: FastRecordViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: - UI
    private let plusButtonView = PlusButtonView()
    private let plusViewTapGesture = UITapGestureRecognizer()
    private let cantRecordLabel = CantRecordLabel()
    
    private let recordBaseView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 20.0
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.masksToBounds = false
        view.layer.shadowRadius = 4.0
        view.layer.shadowOffset = .zero
        view.layer.shadowOpacity = 0.2
        return view
    }()
    
    private let fastTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .label
        label.text = "16시간 / 16시간"
        label.sizeToFit()
        return label
    }()
    
    private let fastStartLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyMedium
        label.textColor = .systemGray
        label.text = "시작 시간"
        label.sizeToFit()
        return label
    }()
    
    private let fastStartTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyMedium
        label.textColor = .label
        label.text = "10월 18일 19시 0분"
        label.sizeToFit()
        return label
    }()
    
    private let fastEndLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyMedium
        label.textColor = .systemGray
        label.text = "종료 시간"
        label.sizeToFit()
        return label
    }()
    
    private let fastEndTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyMedium
        label.textColor = .label
        label.text = "10월 19일 11시 0분"
        label.sizeToFit()
        return label
    }()
    
    private let horizontalSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        return view
    }()
    
    private let verticalSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        return view
    }()
    
    private let editButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.Localization.RECORD_EDIT, for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .bodyRegural
        button.layer.cornerRadius = 20.0
        return button
    }()
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.Localization.RECORD_DELETE, for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .bodyRegural
        button.layer.cornerRadius = 20.0
        return button
    }()
    
    // MARK: - Lifecycle
    init(viewModel: FastRecordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
        super.configure()
        registerGesture()
        bindViewModel()
    }
    
    override func configureLayout() {
        [
            fastTimeLabel,
            fastStartLabel,
            fastStartTimeLabel,
            fastEndLabel,
            fastEndTimeLabel,
            horizontalSeparatorView,
            verticalSeparatorView,
            editButton,
            deleteButton
        ].forEach { recordBaseView.addSubview($0) }
        
        [
            recordBaseView,
            plusButtonView,
            cantRecordLabel
        ].forEach { view.addSubview($0) }
        
        recordBaseView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24.0)
            $0.horizontalEdges.equalToSuperview().inset(16.0)
            $0.height.equalTo(180.0)
        }
        
        fastTimeLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(20.0)
        }
        fastTimeLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        fastStartLabel.snp.makeConstraints {
            $0.top.equalTo(fastTimeLabel.snp.bottom).offset(20.0)
            $0.leading.equalToSuperview().inset(20.0)
        }
        fastStartLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        fastStartTimeLabel.snp.makeConstraints {
            $0.top.equalTo(fastStartLabel)
            $0.trailing.equalToSuperview().inset(20.0)
        }
        fastStartTimeLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        fastEndLabel.snp.makeConstraints {
            $0.top.equalTo(fastStartLabel.snp.bottom).offset(10.0)
            $0.leading.equalToSuperview().inset(20.0)
        }
        fastEndLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        fastEndTimeLabel.snp.makeConstraints {
            $0.top.equalTo(fastEndLabel)
            $0.trailing.equalToSuperview().inset(20.0)
        }
        fastEndTimeLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        horizontalSeparatorView.snp.makeConstraints {
            $0.top.equalTo(fastEndLabel.snp.bottom).offset(20.0)
            $0.horizontalEdges.equalToSuperview().inset(20.0)
            $0.height.equalTo(1.0)
        }
        
        verticalSeparatorView.snp.makeConstraints {
            $0.top.equalTo(horizontalSeparatorView).offset(6.0)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(6.0)
            $0.width.equalTo(1.0)
        }
        
        editButton.snp.makeConstraints {
            $0.top.equalTo(horizontalSeparatorView.snp.bottom)
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(verticalSeparatorView.snp.leading)
        }
        editButton.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        editButton.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        deleteButton.snp.makeConstraints {
            $0.top.equalTo(editButton)
            $0.bottom.equalTo(editButton)
            $0.leading.equalTo(verticalSeparatorView.snp.trailing)
            $0.trailing.equalToSuperview()
        }
        deleteButton.setContentHuggingPriority(.defaultHigh, for: .vertical)
        deleteButton.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        plusButtonView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24.0)
            $0.horizontalEdges.equalToSuperview().inset(16.0)
            $0.height.equalTo(180.0)
        }
        
        cantRecordLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(48.0)
            $0.centerX.equalToSuperview()
        }
    }
}

private extension FastRecordViewController {
    func bindViewModel() {
        let input = FastRecordViewModel.Input(
            plusViewTapped: plusViewTapGesture.rx.event.map { _ in }
        )
        
        let output = viewModel.transform(input: input)
        
        output.plusViewIsHidden
            .asDriver()
            .drive(plusButtonView.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.recordViewIsHidden
            .asDriver()
            .drive(recordBaseView.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.cantRecordLabelIsHidden
            .asDriver()
            .drive(cantRecordLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.fastTimeText
            .asDriver()
            .drive(fastTimeLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.fastStartTime
            .asDriver()
            .map { $0.toString(format: .currentFastTimeFormat2) }
            .drive(fastStartTimeLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.fastEndTime
            .asDriver()
            .map { $0.toString(format: .currentFastTimeFormat2) }
            .drive(fastEndTimeLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func registerGesture() {
        plusButtonView.addGestureRecognizer(plusViewTapGesture)
    }
}
