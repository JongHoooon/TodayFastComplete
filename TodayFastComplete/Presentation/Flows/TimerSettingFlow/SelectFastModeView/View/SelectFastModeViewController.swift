//
//  SelectTimerModeViewController.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/5/23.
//

import UIKit

import RxCocoa
import RxSwift

final class SelectFastModeViewController: BaseViewController {

    // MARK: - Properties
    private let viewModel: SelectFastModeViewModel
    private let disposeBag: DisposeBag
    
    // MARK: - UI
    private let selectFastModeCollectionView = SelectFastModeCollectionView()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyRegural
        label.numberOfLines = 0
        return label
    }()
    
    private let nextBarButton = UIBarButtonItem(
        title: Constants.Localization.NEXT,
        style: .done,
        target: nil,
        action: nil
    )
    
    private let dismissBarButton = UIBarButtonItem(
        image: Constants.Icon.xmark,
        style: .plain,
        target: nil,
        action: nil
    )
    
    // MARK: - Lifecycle
    init(viewModel: SelectFastModeViewModel) {
        self.viewModel = viewModel
        disposeBag = DisposeBag()
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
        bindViewModel()
    }
    
    override func configureNavigationBar() {
        navigationItem.title = Constants.Localization.TIMER_MODE_SELECT_VIEW_TITLE
        navigationItem.leftBarButtonItem = dismissBarButton
        navigationItem.rightBarButtonItem = nextBarButton
    }
    
    override func configureLayout() {
        [
            selectFastModeCollectionView,
            infoLabel
        ].forEach { view.addSubview($0) }
        
        selectFastModeCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(36.0)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(200.0)
        }
        
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(selectFastModeCollectionView.snp.bottom).offset(24.0)
            $0.horizontalEdges.equalToSuperview().inset(24.0)
        }
    }
}

private extension SelectFastModeViewController {
    func bindViewModel() {
        
        let input = SelectFastModeViewModel.Input(
            viewDidLoad: self.rx.viewDidLoad.asObservable(),
            viewDidDismissed: self.rx.viewDidDismissed.asObservable(),
            modeSelected: selectFastModeCollectionView.rx.modelSelected(FastMode.self).asObservable(),
            nextButtonTapped: nextBarButton.rx.tap.asObservable(),
            dismissButtonTapped: dismissBarButton.rx.tap.asObservable()
        )
        let output = viewModel.transform(input: input)
        
        output.fastModeItems
            .asDriver()
            .do(afterNext: { [weak self] _ in
                self?.selectFastModeCollectionView.selectItem(
                    at: [0, 0],
                    animated: false,
                    scrollPosition: .top
                )
            })
            .drive(selectFastModeCollectionView.rx.items(
                cellIdentifier: SelectFastModeCollectionViewCell.identifier,
                cellType: SelectFastModeCollectionViewCell.self
            )) { _, mode, cell in
                cell.configureCell(mode: mode)
            }
            .disposed(by: disposeBag)
        
        output.infoLabelText
            .asDriver()
            .drive(infoLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
