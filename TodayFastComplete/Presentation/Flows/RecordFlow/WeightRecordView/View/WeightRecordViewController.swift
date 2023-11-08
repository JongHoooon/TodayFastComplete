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
}

private extension WeightRecordViewController {
    func bindViewModel() {
        let input = WeightRecordViewModel.Input()
        let output = viewModel.transform(input: input)
    }
}
