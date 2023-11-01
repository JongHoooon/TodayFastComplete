//
//  WriteFastRecordViewController.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/19/23.
//

import UIKit

import RxCocoa
import RxKeyboard
import RxSwift

final class WriteFastRecordViewController: BaseViewController {
 
    // MARK: - Properties
    private let viewModel: WriteFastRecordViewModel
    private let disposeBag: DisposeBag

    // MARK: - UI
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let scrollContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGroupedBackground
        return view
    }()
    
    private let scrollContentViewTapGesture = UITapGestureRecognizer()

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
        label.font = .subtitleBold
        label.textColor = .label
        label.textAlignment = .center
        label.text = Constants.Localization.TOTAL_FAST_TIME_TITLE
        return label
    }()
    
    private let totalTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .custom(size: 36.0, weight: .black)
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
    
    private let fastTimeTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .subtitleBold
        label.text = Constants.Localization.FAST_TIME
        return label
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
    
    private let weightTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .subtitleBold
        label.text = Constants.Localization.WEIGHT_TITLE
        return label
    }()
    
    private let weightBaseView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Color.backgroundMain
        view.layer.cornerRadius = 20.0
        return view
    }()
    
    private let weightBaseViewTap = UITapGestureRecognizer()
    
    private let weightTextField: PasteDisableTextField = {
        let textField = PasteDisableTextField()
        textField.backgroundColor = .clear
        textField.textColor = .label
        textField.tintColor = .tintAccent
        textField.font = .titleBold
        textField.textAlignment = .center
        textField.keyboardType = .decimalPad
        textField.text = "0.0"
        return textField
    }()
    
    private let kgLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .custom(size: 20.0, weight: .bold)
        label.text = "kg"
        return label
    }()
    
    private let plusButton: UIButton = {
        let button = UIButton()
        button.configuration = .filled()
        button.configuration?.image = Constants.Icon.plus?.withTintColor(.label)
        button.configuration?.baseBackgroundColor = .tintAccent
        button.configuration?.cornerStyle = .capsule
        return button
    }()
    
    private let minusButton: UIButton = {
        let button = UIButton()
        button.configuration = .filled()
        button.configuration?.image = Constants.Icon.minus?.withTintColor(.label)
        button.configuration?.baseBackgroundColor = .tintAccent
        button.configuration?.cornerStyle = .capsule
        return button
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
    
    deinit {
        Log.deinit()
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
            fastTimeTitleLabel,
            fastStartTitleView,
            fastStartDatePickerView,
            fastSeparatorView,
            fastEndDatePickerView,
            fastEndTitleView
        ].forEach { fastTimeBaseView.addSubview($0) }
        
        [
            weightTextField,
            kgLabel,
            minusButton,
            plusButton
        ].forEach { weightBaseView.addSubview($0) }
        
        [
            totalTimeTitleLabel,
            totalTimeLabel,
            fastTimeBaseView,
            weightTitleLabel,
            weightBaseView
        ].forEach { scrollContentView.addSubview($0) }
        
        scrollView.addSubview(scrollContentView)
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints {
            $0.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
        
        scrollContentView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.snp.width)
        }
        
        totalTimeTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(16.0)
        }
        
        totalTimeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(totalTimeTitleLabel.snp.bottom).offset(12.0)
        }
        
        fastTimeTitleLabel.snp.makeConstraints {
            $0.top.equalTo(totalTimeLabel.snp.bottom).offset(36.0)
            $0.leading.equalTo(fastTimeBaseView)
        }
        
        fastTimeBaseView.snp.makeConstraints {
            $0.top.equalTo(fastTimeTitleLabel.snp.bottom).offset(8)
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
        
        weightTitleLabel.snp.makeConstraints {
            $0.top.equalTo(fastTimeBaseView.snp.bottom).offset(24.0)
            $0.leading.equalTo(weightBaseView)
        }
        
        weightBaseView.snp.makeConstraints {
            $0.top.equalTo(weightTitleLabel.snp.bottom).offset(8.0)
            $0.horizontalEdges.equalToSuperview().inset(16.0)
            $0.height.equalTo(120.0)
            $0.bottom.equalToSuperview().inset(24.0)
        }
        
        weightTextField.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(60.0)
            $0.width.greaterThanOrEqualTo(0.0)
        }
        
        kgLabel.snp.makeConstraints {
            $0.leading.equalTo(weightTextField.snp.trailing)
            $0.centerY.equalTo(weightTextField).offset(3.0)
        }
        
        minusButton.snp.makeConstraints {
            $0.centerY.equalTo(weightTextField)
            $0.leading.equalToSuperview().inset(24.0)
            $0.size.equalTo(52.0)
        }
        
        plusButton.snp.makeConstraints {
            $0.centerY.equalTo(weightTextField)
            $0.trailing.equalToSuperview().inset(24.0)
            $0.size.equalTo(52.0)
        }
    }
}

private extension WriteFastRecordViewController {
    func bindViewModel() {
        
        let weightTextFieldTextShared = weightTextField.rx.text.orEmpty.share()
        let viewDidLoadShared = self.rx.viewDidLoad.share()
        
        let input = WriteFastRecordViewModel.Input(
            viewDidLoad: self.rx.viewDidLoad.asObservable(), 
            fastStartTitleViewTapped: fastStartTitleViewTapGesture.rx.event.map { _ in },
            fastEndTitleViewTapped: fastEndTitleViewTapGesture.rx.event.map { _ in },
            dismissButtonTapped: dismissBarButton.rx.tap.asObservable(),
            minusWeightButtonTapped: minusButton.rx.tap
                .throttle(.milliseconds(100), latest: false, scheduler: MainScheduler.instance)
                .do(onNext: { _ in UIImpactFeedbackGenerator(style: .soft).impactOccurred() }),
            plusWeightButtonTapped: plusButton.rx.tap
                .throttle(.milliseconds(100), latest: false, scheduler: MainScheduler.instance)
                .do(onNext: { _ in UIImpactFeedbackGenerator(style: .soft).impactOccurred() }),
            startTimeDate: fastStartDatePickerView.rx.value.asObservable(),
            endTimeDate: fastEndDatePickerView.rx.value.asObservable(),
            weightTextFieldText: weightTextFieldTextShared, 
            saveButtonTapped: saveBarButton.rx.tap.asObservable()
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
                owner.fastStartTitleView.rotateChevronImage()
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
                owner.fastEndTitleView.rotateChevronImage()
            })
            .disposed(by: disposeBag)
        
        output.startTimeDate
            .map { $0.toString(format: .currentFastTimeFormat2) }
            .bind(with: self, onNext: { owner, text in
                owner.fastStartTitleView.configureTitleLabel(text: text)
            })
            .disposed(by: disposeBag)
        
        output.endTimeDate
            .map { $0.toString(format: .currentFastTimeFormat2) }
            .bind(with: self, onNext: { owner, text in
                owner.fastEndTitleView.configureTitleLabel(text: text)
            })
            .disposed(by: disposeBag)
        
        output.startDatePickerDate
            .bind(to: fastStartDatePickerView.rx.date)
            .disposed(by: disposeBag)
        
        output.endDatePickerDate
            .bind(to: fastEndDatePickerView.rx.date)
            .disposed(by: disposeBag)
        
        output.totalFastTimeSecond
            .map {
                let text = String(
                    format: Constants.Localization.TOTAL_FAST_TIME,
                    arguments: ["\($0 / 3600)", "\($0 % 3600 / 60)"]
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
                return attributedString
            }
            .bind(to: totalTimeLabel.rx.attributedText)
            .disposed(by: disposeBag)
        
        output.weight
            .map { String(format: "%.1f", $0) }
            .bind(to: weightTextField.rx.text)
            .disposed(by: disposeBag)
    
        viewDidLoadShared
            .bind(with: self, onNext: { owner, _ in
                owner.fastStartDatePickerView.minimumDate = Calendar.current.date(
                    bySettingHour: 0,
                    minute: 0,
                    second: 0,
                    of: owner.viewModel.startDate
                )
                owner.fastStartDatePickerView.maximumDate = Calendar.current.date(
                    bySettingHour: 23,
                    minute: 59,
                    second: 59,
                    of: owner.viewModel.startDate
                )
                owner.fastEndDatePickerView.minimumDate = Calendar.current.date(
                    bySettingHour: 0,
                    minute: 0,
                    second: 0,
                    of: owner.viewModel.startDate
                )
                owner.fastEndDatePickerView.maximumDate = Calendar.current.date(
                    bySettingHour: 23,
                    minute: 59,
                    second: 59,
                    of: owner.viewModel.startDate.addingTimeInterval(24*60*60)
                )
            })
            .disposed(by: disposeBag)
            
        scrollContentViewTapGesture.rx.event
            .asDriver()
            .skip(1)
            .drive(with: self, onNext: { owner, _ in
                owner.view.endEditing(true)
            })
            .disposed(by: disposeBag)
    
        RxKeyboard.instance.visibleHeight
            .filter { $0 != 0 }
            .drive(with: self, onNext: { owner, _ in
                owner.scrollView.scroll(to: .bottom)
            })
            .disposed(by: disposeBag)
        
        weightBaseViewTap.rx.event
            .subscribe(with: self, onNext: { owner, _ in
                switch owner.weightTextField.isFirstResponder {
                case true:      owner.view.endEditing(true)
                case false:     owner.weightTextField.becomeFirstResponder()
                }
            })
            .disposed(by: disposeBag)
        
        weightTextFieldTextShared
            .filter {
                var pointCount = 0
                for c in $0 where c == "." { pointCount += 1 }
                return $0.count > 5
                    || pointCount > 1
                    || ($0.count == 5 && $0.last == ".")
            }
            .map {
                var text = $0
                _ = text.popLast()
                return text
            }
            .bind(to: weightTextField.rx.text)
            .disposed(by: disposeBag)
        
        weightTextFieldTextShared
            .filter { ($0.count == 1 && $0 == ".") }
            .map { "0"+$0 }
            .bind(to: weightTextField.rx.text)
            .disposed(by: disposeBag)
        
        weightTextField.rx.controlEvent(.editingDidEnd)
            .withLatestFrom(weightTextFieldTextShared)
            .filter { $0 == "" }
            .map { _ in "0.0" }
            .bind(to: weightTextField.rx.text)
            .disposed(by: disposeBag)
            
    }
    
    func addGesture() {
        scrollContentView.addGestureRecognizer(scrollContentViewTapGesture)
        fastStartTitleView.addGestureRecognizer(fastStartTitleViewTapGesture)
        fastEndTitleView.addGestureRecognizer(fastEndTitleViewTapGesture)
        weightBaseView.addGestureRecognizer(weightBaseViewTap)
    }
    
    func showDatePicker(pickerView: UIView, isShow: Bool) {
        switch isShow {
        case true:
            pickerView.isHidden = false
            pickerView.snp.updateConstraints {
                $0.height.equalTo(200.0)
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
