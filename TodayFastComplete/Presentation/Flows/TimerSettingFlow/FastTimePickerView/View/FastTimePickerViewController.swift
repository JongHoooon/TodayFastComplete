//
//  FastTimePickerViewController.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/9/23.
//

import UIKit

import RxSwift

final class FastTimePickerViewController: BaseViewController {
    
    // MARK: - Properties
    private let viewModel: FastTimePickerViewModel
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
    private let pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        return pickerView
    }()
    
    // MARK: - Lifecycle
    init(viewModel: FastTimePickerViewModel) {
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
            pickerView,
            toolBar
        ].forEach { view.addSubview($0) }
                
        pickerView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        toolBar.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
        }
    }
}

private extension FastTimePickerViewController {
    func bindViewModel() {
        
        let input = FastTimePickerViewModel.Input(
            cancelButtonTapped: cancelBarButton.rx.tap.asObservable(),
            complteButtonTapped: completeBarButton.rx.tap.asObservable(), 
            itemSelected: pickerView.rx.itemSelected.map { $0.row }
        )
        
        let output = viewModel.transform(input: input)
        
        Observable.just(output.fastTimes)
            .bind(to: pickerView.rx.itemTitles) { _, time in
                return String(
                    localized: "HOURS",
                    defaultValue: "\(time) 시간"
            )}
            .disposed(by: disposeBag)
        // TODO: GA 기반 인기 루틴 기본값으로 
        let defaultFastTime = Constants.DefaultValue.fastTime
        pickerView.selectRow(
            output.fastTimes.firstIndex(of: viewModel.currentFastTime) ?? defaultFastTime,
            inComponent: 0,
            animated: false
        )
    }
}

private extension FastTimePickerViewController {
    func configureToolBar() {
        let spacer = UIBarButtonItem(systemItem: .flexibleSpace)
        toolBar.items = [cancelBarButton, spacer, completeBarButton]
    }
    
    func configureSheet() {
        if let sheet = sheetPresentationController {
            sheet.detents = [.custom(resolver: { $0.maximumDetentValue * 0.45 })]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
    }
}
