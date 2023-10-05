//
//  SelectTimerModeViewController.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/5/23.
//

import UIKit

final class SelectFastModeViewController: BaseViewController {

    // MARK: - Properties
    private let viewModel: SelectFastModeViewModel
    
    // MARK: - UI
    private let selectFastModeCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewLayout()
        )
        return collectionView
    }()
    
    // MARK: - Lifecycle
    init(viewModel: SelectFastModeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
}
