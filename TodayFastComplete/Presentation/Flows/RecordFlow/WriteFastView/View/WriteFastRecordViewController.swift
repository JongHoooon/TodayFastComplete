//
//  WriteFastRecordViewController.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/19/23.
//

import UIKit

final class WriteFastRecordViewController: BaseViewController {
 
    // MARK: - Properties
    private let viewModel: WriteFastRecordViewModel
    
    // MARK: - Lifecycle
    init(viewModel: WriteFastRecordViewModel) {
        self.viewModel = viewModel
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
