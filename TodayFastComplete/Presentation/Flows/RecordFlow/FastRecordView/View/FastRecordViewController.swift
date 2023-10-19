//
//  FastRecordViewController.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/18/23.
//

import UIKit

final class FastRecordViewController: BaseViewController {
    
    // MARK: - Properties
    private let viewModel: FastRecordViewModel
    
    // MARK: - UI
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
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
        
        view.addSubview(button)
        button.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(40.0)
        }
        bindViewModel()
    }
}

private extension FastRecordViewController {
    func bindViewModel() {
        let input = FastRecordViewModel.Input(
            writeFastRecordButtonTapped: button.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input: input)
    }
}
