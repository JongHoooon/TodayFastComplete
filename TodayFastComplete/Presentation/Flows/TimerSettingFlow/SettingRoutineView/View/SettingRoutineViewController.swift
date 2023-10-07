//
//  SettingRoutineViewController.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/5/23.
//

import UIKit

import RxCocoa
import RxSwift

final class SettingRoutineViewController: BaseViewController {
    
    // MARK: - Properties
    private let viewModel: SettingRoutineViewModel
    private let disposeBag: DisposeBag
    
    private let weekDays = WeekDay.allCases
    private let reconmmendFastRoutines = [
        FastRoutine(fastingTime: 16, mealCount: 2, image: Constants.Imgage.fasting),
        FastRoutine(fastingTime: 12, mealCount: 3, image: Constants.Imgage.fasting),
        FastRoutine(fastingTime: 23, mealCount: 1, image: Constants.Imgage.fasting)
    ]
    private let customFastRoutines = [
        FastRoutine(fastingTime: 16),
        FastRoutine(fastingTime: 12),
        FastRoutine(fastingTime: 23)
    ]
    
    // MARK: - UI
    private let settingRoutineCollectionView = SettingRoutineCollectionView()
    private var dataSource: UICollectionViewDiffableDataSource<SettingRoutineSection, SettingRoutineItem>!
    
    private let saveBarButton = UIBarButtonItem(
        title: Constants.Localization.SAVE,
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
    init(viewModel: SettingRoutineViewModel) {
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
        configureDataSource()
        applySnapShots()
    }
    
    override func configureNavigationBar() {
        navigationItem.title = Constants.Localization.SETTING_TIMER_TITLE
        navigationItem.leftBarButtonItem = dismissBarButton
        navigationItem.rightBarButtonItem = saveBarButton
    }
    
    override func configureLayout() {
        [
            settingRoutineCollectionView
        ].forEach { view.addSubview($0) }
        
        settingRoutineCollectionView.collectionViewLayout = configureCollectionViewLayout()
        settingRoutineCollectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

private extension SettingRoutineViewController {
    func bindViewModel() {
        let input = SettingRoutineViewModel.Input(
            viewDidDismissed: self.rx.viewDidDismissed,
            dismissButtonTapped: dismissBarButton.rx.tap
        )
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
    }
}

private extension SettingRoutineViewController {
    enum SettingRoutineSection: Int, CaseIterable {
        case day = 0
        case startTime
        case recommendRoutine
        case customRoutine
        
        var title: String {
            switch self {
            case .day:
                return String(localized: "SELECT_WEEKDAY", defaultValue: "요일 선택")
            case .startTime:
                return String(localized: "START_TIME", defaultValue: "시작 시간")
            case .recommendRoutine:
                return String(localized: "RECOMMEND_FAST_ROUTINE", defaultValue: "추천 단식 루틴")
            case .customRoutine:
                return String(localized: "CUSTOM_FAST_ROUTINE", defaultValue: "나만의 단식 루틴")
            }
        }
    }

    enum SettingRoutineItem: Hashable {
        case dayItem(weekDay: WeekDay)
        case startTimeItem
        case recommendRoutineItem(routine: FastRoutine)
        case customRoutineItem(routine: FastRoutine)
    }
    
    func configureCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnviroment in
            guard let settingRoutineSection = SettingRoutineSection(rawValue: sectionIndex) else { return nil }
            
            var section: NSCollectionLayoutSection?
            // item 설정
            switch settingRoutineSection {
            case .day:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0/7.0),
                    heightDimension: .fractionalHeight(1.0)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(52.0)
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    repeatingSubitem: item,
                    count: 7
                )
                group.interItemSpacing = .fixed(4.0)
                section = NSCollectionLayoutSection(group: group)
                
            case .startTime:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(80.0)
                )
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: groupSize,
                    repeatingSubitem: item,
                    count: 1
                )
                section = NSCollectionLayoutSection(group: group)
            case .recommendRoutine, .customRoutine:
                var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
                // TODO: configure swipe
                section = NSCollectionLayoutSection.list(
                    using: configuration,
                    layoutEnvironment: layoutEnviroment
                )
                section?.interGroupSpacing = 16.0
            }
            
            // section insets 설정
            switch settingRoutineSection {
            case .recommendRoutine:
                section?.contentInsets = NSDirectionalEdgeInsets(
                    top: 0.0,
                    leading: 16.0,
                    bottom: 16.0,
                    trailing: 16.0
                )
            case .customRoutine:
                section?.contentInsets = NSDirectionalEdgeInsets(
                    top: 0.0,
                    leading: 16.0,
                    bottom: 16.0,
                    trailing: 16.0
                )
            default:
                section?.contentInsets = NSDirectionalEdgeInsets(
                    top: 0.0,
                    leading: 16.0,
                    bottom: 0.0,
                    trailing: 16.0
                )
            }
            
            // header 설정
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(40.0)
            )
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            switch settingRoutineSection {
            case .recommendRoutine, .customRoutine:
                header.contentInsets = NSDirectionalEdgeInsets(
                    top: 0,
                    leading: 16.0,
                    bottom: 0,
                    trailing: 16.0
                )
            default:
                break
            }
            section?.boundarySupplementaryItems = [header]
            
            return section
        }
        return layout
    }
    
    func configureDataSource() {
        let dayCellRegistration = createDayCellRegistration()
        let startTimeCellRegistration = createStartTimeCellRegistration()
        let fastRoutineCellRegistration = createFastRoutineCellRegistration()
        let titleHeaderRegistration = createTitleCollectionHeaderCellRegistration()
        let customRoutineHeaderRegistration = createCustomRuotineHeaderRegistration()
        
        dataSource = UICollectionViewDiffableDataSource<SettingRoutineSection, SettingRoutineItem>(
            collectionView: settingRoutineCollectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                let section = SettingRoutineSection(rawValue: indexPath.section)
                
                var item: Any?
                switch itemIdentifier {
                case .dayItem(let weekDay):
                    item = weekDay
                case .startTimeItem:
                    item = nil
                case .recommendRoutineItem(let routine):
                    item = routine
                case .customRoutineItem(let routine):
                    item = routine
                }
                
                switch section {
                case .day:
                    return collectionView.dequeueConfiguredReusableCell(
                        using: dayCellRegistration,
                        for: indexPath,
                        item: item as? WeekDay
                    )
                case .startTime:
                    return collectionView.dequeueConfiguredReusableCell(
                        using: startTimeCellRegistration,
                        for: indexPath,
                        item: 0
                    )
                case .recommendRoutine, .customRoutine:
                    return collectionView.dequeueConfiguredReusableCell(
                        using: fastRoutineCellRegistration,
                        for: indexPath,
                        item: item as? FastRoutine
                    )
                case nil:
                    assertionFailure("section is not exist")
                    return UICollectionViewCell()
                }
            }
        )
        
        dataSource.supplementaryViewProvider = { collectionView, _, indexPath in
            let section = SettingRoutineSection(rawValue: indexPath.section)
            let view: UICollectionReusableView
            
            switch section {
            case .customRoutine:
                view = collectionView.dequeueConfiguredReusableSupplementary(
                    using: customRoutineHeaderRegistration,
                    for: indexPath
                )
            default:
                view = collectionView.dequeueConfiguredReusableSupplementary(
                    using: titleHeaderRegistration,
                    for: indexPath
                )
            }
            return view
        }
    }
    
    func applySnapShots() {
        var snapshot = NSDiffableDataSourceSnapshot<SettingRoutineSection, SettingRoutineItem>()
        snapshot.appendSections(SettingRoutineSection.allCases)
        
        weekDays.forEach {
            snapshot.appendItems([.dayItem(weekDay: $0)], toSection: .day)
        }
        snapshot.appendItems([.startTimeItem], toSection: .startTime)
        reconmmendFastRoutines.forEach {
            snapshot.appendItems([.recommendRoutineItem(routine: $0)], toSection: .recommendRoutine)
        }
        customFastRoutines.forEach {
            snapshot.appendItems([.customRoutineItem(routine: $0)], toSection: .customRoutine)
        }
        dataSource.apply(snapshot)
    }
    
    func createDayCellRegistration() -> UICollectionView.CellRegistration<DayCollectionViewCell, WeekDay> {
        return UICollectionView.CellRegistration<DayCollectionViewCell, WeekDay> { cell, _, weekDay in
            cell.configureCell(with: weekDay)
        }
    }
    
    func createStartTimeCellRegistration() -> UICollectionView.CellRegistration<StartTimeCollectionViewCell, Int> {
        return UICollectionView.CellRegistration<StartTimeCollectionViewCell, Int> { _, _, _ in
        }
    }
    
    func createFastRoutineCellRegistration() -> UICollectionView.CellRegistration<FastRoutineCollectionViewCell, FastRoutine> {
        return UICollectionView.CellRegistration<FastRoutineCollectionViewCell, FastRoutine> { cell, _, fastRoutine in
            cell.item = fastRoutine
        }
    }
    
    func createTitleCollectionHeaderCellRegistration() -> UICollectionView.SupplementaryRegistration<TitleCollectionViewHeader> {
        return UICollectionView.SupplementaryRegistration(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, _, indexPath in
            guard let title = SettingRoutineSection(rawValue: indexPath.section)?.title
            else {
                assertionFailure("no section title")
                return
            }
            supplementaryView.configureCell(with: title)
        }
    }
    
    func createCustomRuotineHeaderRegistration() -> UICollectionView.SupplementaryRegistration<CustomRoutineCollectionViewHeader> {
        return UICollectionView.SupplementaryRegistration(
            elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, _, indexPath in
                guard let title = SettingRoutineSection(rawValue: indexPath.section)?.title
                else {
                    assertionFailure("no section title")
                    return
                }
                supplementaryView.configureCell(with: title)
            }
    }
}
