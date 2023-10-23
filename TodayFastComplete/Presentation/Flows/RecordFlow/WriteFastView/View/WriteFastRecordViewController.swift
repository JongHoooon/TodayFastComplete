//
//  WriteFastRecordViewController.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/19/23.
//

import UIKit

import RxCocoa
import RxSwift

final class WriteFastRecordViewController: BaseViewController {
 
    // MARK: - Properties
    private let viewModel: WriteFastRecordViewModel
    private let disposeBag: DisposeBag

    // MARK: - UI
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private let scrollContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGroupedBackground
        return view
    }()
    
    private let scrollContentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 0.0
        stackView.axis = .vertical
        return stackView
    }()
    
    private let dismissBarButton = UIBarButtonItem(
        image: Constants.Icon.xmark,
        style: .plain,
        target: nil,
        action: nil
    )
    
    private let saveBarButton = UIBarButtonItem(
        title: Constants.Localization.SAVE,
        style: .done,
        target: nil,
        action: nil
    )
    
    private let totalTimeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyRegural
        label.textColor = .label
        label.textAlignment = .center
        label.text = Constants.Localization.TOTAL_FAST_TIME_TITLE
        return label
    }()
    
    private let totalTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .custom(size: 32.0, weight: .black)
        label.textColor = .label
        label.textAlignment = .center
        let text = String(
            format: Constants.Localization.TOTAL_FAST_TIME,
            arguments: ["\(18)", "\(33)"]
        )
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(
            .font,
            value: UIFont.bodyBold,
            range: (text as NSString).range(of: Constants.Localization.HOUR)
        )
        attributedString.addAttribute(
            .font,
            value: UIFont.bodyBold,
            range: (text as NSString).range(of: Constants.Localization.MINUTE)
        )
        label.textColor = .label
        label.attributedText = attributedString
        return label
    }()
    
    private let fastTimeBaseView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Color.backgroundMain
        view.layer.cornerRadius = 20.0
        return view
    }()
    
    private let fastStartTitleView = FastTitleView(style: .start)
    
    private let fastStartDatePickerView: UIDatePicker = {
        let pickerView = UIDatePicker()
        pickerView.datePickerMode = .dateAndTime
        pickerView.preferredDatePickerStyle = .wheels
        pickerView.timeZone = .autoupdatingCurrent
        pickerView.backgroundColor = Constants.Color.backgroundMain
        return pickerView
    }()
    
    private let fastSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        return view
    }()
    
    private let fastEndTitleView = FastTitleView(style: .end)
    
    private let fastEndDatePickerView: UIDatePicker = {
        let pickerView = UIDatePicker()
        pickerView.datePickerMode = .dateAndTime
        pickerView.preferredDatePickerStyle = .wheels
        pickerView.timeZone = .autoupdatingCurrent
        pickerView.backgroundColor = Constants.Color.backgroundMain
        return pickerView
    }()
    
    private let fastStartTitleViewTapGesture = UITapGestureRecognizer()
    private let fastEndTitleViewTapGesture = UITapGestureRecognizer()
    
    private let weightBaseView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Color.backgroundMain
        return view
    }()

    // MARK: - Lifecycle
    init(viewModel: WriteFastRecordViewModel) {
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
        view.backgroundColor = .systemGroupedBackground
        addGesture()
        bindViewModel()
    }
    
    override func configureNavigationBar() {
        navigationItem.leftBarButtonItem = dismissBarButton
        navigationItem.rightBarButtonItem = saveBarButton
    }
    
    override func configureLayout() {
        
        [
            fastStartTitleView,
            fastStartDatePickerView,
            fastSeparatorView,
            fastEndDatePickerView,
            fastEndTitleView
        ].forEach { fastTimeBaseView.addSubview($0) }
        
        [
            totalTimeTitleLabel,
            totalTimeLabel,
            fastTimeBaseView
        ].forEach { scrollContentStackView.addArrangedSubview($0) }
        
        scrollView.addSubview(scrollContentStackView)
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
//        scrollContentView.snp.makeConstraints {
//            $0.edges.equalTo(scrollView.contentLayoutGuide)
//            $0.bottom.equalTo(fastTimeBaseView).offset(60.0)
//            $0.width.equalTo(scrollView.snp.width)
//            $0.leading.trailing.top.bottom.equalTo(scrollView.contentLayoutGuide)
//            $0.width.equalTo(scrollView.snp.width)
//            $0.bottom.equalTo(fastTimeBaseView).offset(60.0)
//        }
        
        totalTimeTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16.0)
        }
        
        totalTimeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(totalTimeTitleLabel.snp.bottom).offset(12.0)
        }
        
        fastTimeBaseView.snp.makeConstraints {
            $0.top.equalTo(totalTimeLabel.snp.bottom).offset(48.0)
            $0.leading.trailing.equalToSuperview().inset(16.0)
        }
        
        fastStartTitleView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16.0)
            $0.leading.trailing.equalToSuperview().inset(16.0)
            $0.height.equalTo(32.0)
        }
        
        fastStartDatePickerView.snp.makeConstraints {
            $0.top.equalTo(fastStartTitleView.snp.bottom)
            $0.horizontalEdges.equalTo(fastStartTitleView)
            $0.height.equalTo(0.0)
        }
        
        fastSeparatorView.snp.makeConstraints {
            $0.top.equalTo(fastStartDatePickerView.snp.bottom).offset(16.0)
            $0.leading.trailing.equalToSuperview().inset(16.0)
            $0.height.equalTo(0.5)
        }
        
        fastEndTitleView.snp.makeConstraints {
            $0.top.equalTo(fastSeparatorView.snp.bottom).offset(16.0)
            $0.leading.trailing.equalToSuperview().inset(16.0)
            $0.height.equalTo(32.0)
        }
        
        fastEndDatePickerView.snp.makeConstraints {
            $0.top.equalTo(fastEndTitleView.snp.bottom).offset(16.0)
            $0.horizontalEdges.equalTo(fastEndTitleView)
            $0.height.equalTo(0.0)
            $0.bottom.equalToSuperview()
        }
    }
}

private extension WriteFastRecordViewController {
    func bindViewModel() {
        let input = WriteFastRecordViewModel.Input(
            fastStartTitleViewTapped: fastStartTitleViewTapGesture.rx.event.map { _ in },
            fastEndTitleViewTapped: fastEndTitleViewTapGesture.rx.event.map { _ in },
            dismissButtonTapped: dismissBarButton.rx.tap.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        output.startDatePickerIsShow
            .asDriver()
            .skip(1)
            .drive(with: self, onNext: { owner, isShow in
                owner.showDatePicker(
                    pickerView: owner.fastStartDatePickerView,
                    isShow: isShow
                )
            })
            .disposed(by: disposeBag)
        
        output.endDatePickerIsShow
            .asDriver()
            .skip(1)
            .drive(with: self, onNext: { owner, isShow in
                owner.showDatePicker(
                    pickerView: owner.fastEndDatePickerView,
                    isShow: isShow
                )
            })
            .disposed(by: disposeBag)
    }
    
    func addGesture() {
        fastStartTitleView.addGestureRecognizer(fastStartTitleViewTapGesture)
        fastEndTitleView.addGestureRecognizer(fastEndTitleViewTapGesture)
//        view.addGestureRecognizer(fastStartTitleViewTapGesture)
//        view.addGestureRecognizer(fastEndTitleViewTapGesture)
    }
    
    func showDatePicker(pickerView: UIView, isShow: Bool) {
        switch isShow {
        case true:
            pickerView.isHidden = false
            pickerView.snp.updateConstraints {
                $0.height.equalTo(400.0)
            }
            
        case false:
            pickerView.isHidden = true
            pickerView.snp.updateConstraints {
                $0.height.equalTo(0.0)
            }
        }
        
        UIView.animate(
            withDuration: 0.3,
            animations: { [weak self] in
                self?.view.layoutIfNeeded()
        })
    }
}
