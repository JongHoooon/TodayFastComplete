//
//  WeightRecordViewController.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/18/23.
//

import UIKit

import RxSwift

final class WeightRecordViewController: BaseViewController {
    
    // MARK: - Properties
    private let viewModel: WeightRecordViewModel
    private let disposeBag: DisposeBag
    
    // MARK: - UI
    private let plusButtonView = PlusButtonView()
    private let plusViewTapGesture = UITapGestureRecognizer()
    private let cantRecordLabel = CantRecordLabel()
    
    private let recordBaseView = RecordBaseView()
    
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
    
    private let weightLabel: UILabel = {
        let label = UILabel()
        label.font = .titleBold
        label.textColor = .label
        label.text = "77.7 kg"
        return label
    }()
         
    // MARK: - Lifecycle
    init(viewModel: WeightRecordViewModel) {
        self.viewModel = viewModel
        self.disposeBag = DisposeBag()
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
        bindViewModel()
        registerGesture()
    }
    
    override func configureLayout() {
        [
            horizontalSeparatorView,
            verticalSeparatorView,
            editButton,
            deleteButton,
            weightLabel
        ].forEach { recordBaseView.addSubview($0) }
        
        [
            plusButtonView,
            cantRecordLabel,
            recordBaseView
        ].forEach { view.addSubview($0) }
        
        plusButtonView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24.0)
            $0.horizontalEdges.equalToSuperview().inset(16.0)
            $0.height.equalTo(180.0)
        }
        
        cantRecordLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(48.0)
            $0.centerX.equalToSuperview()
        }
        
        recordBaseView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24.0)
            $0.horizontalEdges.equalToSuperview().inset(16.0)
            $0.height.equalTo(180.0)
        }
        
        horizontalSeparatorView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20.0)
            $0.height.equalTo(1.0)
            $0.bottom.equalTo(editButton.snp.top)
        }
        
        verticalSeparatorView.snp.makeConstraints {
            $0.top.equalTo(horizontalSeparatorView.snp.bottom).offset(6.0)
            $0.bottom.equalToSuperview().inset(6.0)
            $0.width.equalTo(1.0)
            $0.centerX.equalToSuperview()
        }
        verticalSeparatorView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        editButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(verticalSeparatorView.snp.leading)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(51.0)
        }
        
        deleteButton.snp.makeConstraints {
            $0.leading.equalTo(verticalSeparatorView.snp.trailing)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(editButton)
        }
        
        weightLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(8.0)
            $0.bottom.equalTo(horizontalSeparatorView.snp.top).offset(-8.0)
        }
    }
}

private extension WeightRecordViewController {
    func bindViewModel() {
        let input = WeightRecordViewModel.Input(
            plusViewTapped: plusViewTapGesture.rx.event.map { _ in },
            editButtonTapped: editButton.rx.tap.asObservable(),
            deleteButtonTapped: deleteButton.rx.tap.asObservable()
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
        
        output.weight
            .map { "\(String(format: "%.1f", $0))kg" }
            .bind(to: weightLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func registerGesture() {
        plusButtonView.addGestureRecognizer(plusViewTapGesture)
    }
}
