//
//  SelectFastModeCollectionView.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/5/23.
//

import UIKit

final class SelectFastModeCollectionView: UICollectionView {
    
    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        registerCell()
        configureLayout()
        alwaysBounceVertical = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLayout() {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.50),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(200.0)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            repeatingSubitem: item,
            count: 2
        )
        group.interItemSpacing = .fixed(24.0)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0.0,
            leading: 24.0,
            bottom: 0.0,
            trailing: 24.0
        ) 
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        self.collectionViewLayout = layout
    }
}

private extension SelectFastModeCollectionView {
    func registerCell() {
        register(
            SelectFastModeCollectionViewCell.self,
            forCellWithReuseIdentifier: SelectFastModeCollectionViewCell.identifier)
    }
}
