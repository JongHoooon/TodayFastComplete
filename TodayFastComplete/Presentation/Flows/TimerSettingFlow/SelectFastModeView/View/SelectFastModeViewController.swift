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
        navigationItem.leftBarButtonItem = dismissBarButton
    }
    
    override func configureLayout() {
        [
            selectFastModeCollectionView
        ].forEach { view.addSubview($0) }
        
        selectFastModeCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(36.0)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(200.0)
        }
    }
}

private extension SelectFastModeViewController {
    func bindViewModel() {
        
        let input = SelectFastModeViewModel.Input(
            viewDidLoad: self.rx.viewDidLoad,
            viewDidDismissed: self.rx.viewDidDismissed,
            dismissButtonTapped: dismissBarButton.rx.tap
        )
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        output.fastModeItems
            .asDriver()
            .drive(selectFastModeCollectionView.rx.items(
                cellIdentifier: SelectFastModeCollectionViewCell.identifier,
                cellType: SelectFastModeCollectionViewCell.self
            )) { _, mode, cell in
                cell.configureCell(mode: mode)
            }
            .disposed(by: disposeBag)
    }
}
