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
    }
    
    override func configureLayout() {
        [
            plusButtonView,
            cantRecordLabel
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
    }
}

private extension WeightRecordViewController {
    func bindViewModel() {
        let input = WeightRecordViewModel.Input()
        let output = viewModel.transform(input: input)
        
        output.plusViewIsHidden
            .asDriver()
            .drive(plusButtonView.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.recordViewIsHidden
            .asDriver()
        
        output.cantRecordLabelIsHidden
            .asDriver()
            .drive(cantRecordLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
}
