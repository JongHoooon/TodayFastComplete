//
//  RecordMainViewController.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/17/23.
//

import UIKit

final class RecordMainViewController: BaseViewController {
    
    // MARK: - Property
    private let viewModel: RecordMainViewModel
    
    // MARK: - Lifecycle
    init(viewModel: RecordMainViewModel) {
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
    
    override func configure() {
        super.configure()
    }
    
    override func configureNavigationBar() {
        navigationItem.title = Constants.Localization.RECORD_TITLE
    }
    
    override func configureLayout() {
        
    }
}
