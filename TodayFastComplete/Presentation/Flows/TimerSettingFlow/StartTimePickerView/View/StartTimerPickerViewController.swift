//
//  TimePickerViewController.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/9/23.
//

import UIKit

import RxSwift

final class StartTimerPickerViewController: BaseViewController {
    
    // MARK: - Properties
    private let viewModel: StartTimePickerViewModel
    private let disposeBag: DisposeBag
    
    // MARK: - UI
    let toolBar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.tintColor = .label
        toolBar.barTintColor = Constants.Color.backgroundMain
        toolBar.sizeToFit()
        return toolBar
    }()
    let completeBarButton: UIBarButtonItem = UIBarButtonItem(
        title: Constants.Localization.COMPLETE,
        style: .done,
        target: nil,
        action: nil
    )
    let cancelBarButton = UIBarButtonItem(
        title: Constants.Localization.CANCEL,
        style: .plain,
        target: nil,
        action: nil
    )
    private let datePickerView: UIDatePicker = {
        let pickerView = UIDatePicker()
        pickerView.datePickerMode = .time
        pickerView.preferredDatePickerStyle = .wheels
        pickerView.timeZone = .autoupdatingCurrent
        pickerView.backgroundColor = Constants.Color.backgroundMain
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        if let date = formatter.date(from: "19:00") {
            pickerView.date = date
        }
        return pickerView
    }()
    
    // MARK: - Lifecycle
    init(viewModel: StartTimePickerViewModel) {
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
        super.configure()
        configureToolBar()
        configureSheet()
        bindViewModel()
    }
    
    override func configureLayout() {
        [
            datePickerView,
            toolBar
        ].forEach { view.addSubview($0) }
                
        datePickerView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        toolBar.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
        }
    }
}

private extension StartTimerPickerViewController {
    func bindViewModel() {
//        datePickerView.rx.date
//            .subscribe(onNext: {
//                Log.debug($0)
//            })
//            .disposed(by: disposeBag)
//        
//        datePickerView.rx.value
//            .subscribe(onNext: {
//                Log.debug($0)
//                let formatter = DateFormatter()
//                formatter.locale = .autoupdatingCurrent
//                formatter.dateFormat = "a h시 m분"
//                let formattedDate = formatter.string(from: $0)
//                Log.debug(formattedDate)
//            })
//            .disposed(by: disposeBag)
        
        let complteTapped = completeBarButton.rx.tap
            .withLatestFrom(datePickerView.rx.date)
            .asObservable()
        
        let input = StartTimePickerViewModel.Input(
            cancelButtonTapped: cancelBarButton.rx.tap.asObservable(),
            complteButtonTapped: complteTapped
        )
        
        _ = viewModel.transform(input: input, disposeBag: disposeBag)
    }
}

private extension StartTimerPickerViewController {
    func configureToolBar() {
        let spacer = UIBarButtonItem(systemItem: .flexibleSpace)
        toolBar.items = [cancelBarButton, spacer, completeBarButton]
    }
    
    func configureSheet() {
        // 밑으로 내려도 dissmiss 방지
        if let sheet = sheetPresentationController {
            sheet.detents = [.custom(resolver: { $0.maximumDetentValue * 0.45 })]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
    }
}
