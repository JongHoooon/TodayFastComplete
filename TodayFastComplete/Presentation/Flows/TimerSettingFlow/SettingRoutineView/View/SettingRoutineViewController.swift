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
    private var dayCellDisposeBag: [UICollectionViewCell: DisposeBag] = [:]
    private var timeSettingCellDisposeBag: [UICollectionViewCell: DisposeBag] = [:]
    private var recommendRoutineCellDisposeBag: [UICollectionViewCell: DisposeBag] = [:]
    private var deleteSettingCellDisposeBag: [UICollectionViewCell: DisposeBag] = [:]
    
    // MARK: - UI
    private let settingRoutineCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewLayout()
        )
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = Constants.Color.backgroundMain
        return collectionView
    }()
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
            $0.bottom.equalToSuperview()
        }
    }
}

private extension SettingRoutineViewController {
    func bindViewModel() {
        
        let timePickerViewTapped = PublishRelay<TimePickerViewType>()
        let itemSelected = settingRoutineCollectionView.rx.itemSelected
            .do(onNext: { _ in UIImpactFeedbackGenerator(style: .soft).impactOccurred() })
            
        let deleteRoutineSettingButtonTapped = PublishRelay<Void>()
            
        let input = SettingRoutineViewModel.Input(
            viewDidLoad: self.rx.viewDidLoad.asObservable(),
            viewDidDismissed: self.rx.viewDidDismissed.asObservable(),
            dismissButtonTapped: dismissBarButton.rx.tap.asObservable(),
            itemSelected: itemSelected,
            timePickerViewTapped: timePickerViewTapped.asObservable(),
            deleteRoutineSettingButtonTapped: deleteRoutineSettingButtonTapped
                .do(onNext: { _ in UIImpactFeedbackGenerator(style: .soft).impactOccurred() }),
            saveButtonTapped: saveBarButton.rx.tap.asObservable()
        )
        var output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        configureDataSource(
            selectedWeekDays: output.selectedWeekDays,
            timePickerViewTapped: timePickerViewTapped, 
            selectedStartTime: output.selectedStartTime, 
            selectedFastTime: output.selectedFastTime,
            selectedRecommendRoutine: output.selectedRecommendRoutine,
            selectedFastInfo: output.selectedRoutineInfo, 
            deleteRoutineSettingButtonTapped: deleteRoutineSettingButtonTapped, 
            deleteButtonIsEnable: output.deleteButtonIsEnable
        )
        var snapshot = NSDiffableDataSourceSnapshot<SettingRoutineSection, SettingRoutineItem>()
        snapshot.appendSections(output.sections)
        snapshot.appendItems(output.weekDaySectionItems, toSection: .dayTime)
        snapshot.appendItems(output.timeSettingSectionItems, toSection: .timeSetting)
        snapshot.appendItems(output.recommendSectionItems, toSection: .recommendRoutine)
        snapshot.appendItems(output.deleteRoutineSettingSectionItems, toSection: .deleteRoutineSetting)
        dataSource.apply(snapshot)
        
        settingRoutineCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        output.saveButtonIsEnable
            .asDriver()
            .drive(saveBarButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}

// MARK: - Setting Routine Collection view
private extension SettingRoutineViewController {
    
    func configureCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let settingRoutineSection = SettingRoutineSection(rawValue: sectionIndex) else { return nil }
            
            var section: NSCollectionLayoutSection?
            // item 설정
            switch settingRoutineSection {
            case .dayTime:
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
                    count: WeekDay.allCases.count
                )
                group.interItemSpacing = .fixed(4.0)
                section = NSCollectionLayoutSection(group: group)
                
            case .timeSetting:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(240.0)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(240.0)
                )
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: groupSize,
                    subitems: [item]
                )
                section = NSCollectionLayoutSection(group: group)
                
            case .recommendRoutine:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(120.0)
                )
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: groupSize,
                    subitems: [item]
                )
                section = NSCollectionLayoutSection(group: group)
                section?.interGroupSpacing = 16.0
                
            case .deleteRoutineSetting:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let buttonHeiht = 64.0
                let buttonInest = 16.0
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(buttonHeiht + buttonInest * 2)
                )
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: groupSize,
                    subitems: [item]
                )
                section = NSCollectionLayoutSection(group: group)
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
            default:
                section?.contentInsets = NSDirectionalEdgeInsets(
                    top: 0.0,
                    leading: 16.0,
                    bottom: 0.0,
                    trailing: 16.0
                )
            }
            
            // header 설정
            switch settingRoutineSection {
            case .deleteRoutineSetting:
                break
            default:
                let headerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(40.0)
                )
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top
                )
                section?.boundarySupplementaryItems = [header]
            }
            
            return section
        }
        return layout
    }
    
    func configureDataSource(
        selectedWeekDays: BehaviorRelay<[Int]>,
        timePickerViewTapped: PublishRelay<TimePickerViewType>,
        selectedStartTime: BehaviorRelay<DateComponents>,
        selectedFastTime: BehaviorRelay<Int>,
        selectedRecommendRoutine: BehaviorRelay<Int?>,
        selectedFastInfo: BehaviorRelay<String>,
        deleteRoutineSettingButtonTapped: PublishRelay<Void>,
        deleteButtonIsEnable: BehaviorRelay<Bool>
    ) {
        let dayCellRegistration = createDayCellRegistration(selectedDays: selectedWeekDays)
        let routineSettingCellRegistration = createTimeSettingCellRegistration(
            timePickerViewTapped: timePickerViewTapped,
            selectedStartTime: selectedStartTime, 
            selectedFastTime: selectedFastTime,
            selectedFastInfo: selectedFastInfo
        )
        let fastRoutineCellRegistration = createRoutineRecommendCellRegistration(selectedRecommendRoutine: selectedRecommendRoutine)
        let titleHeaderRegistration = createTitleCollectionHeaderCellRegistration()
        let deleteRoutineCellRegistration = createDeleteRoutineSettingCellRegistration(
            deleteRoutineSettingButtonTapped: deleteRoutineSettingButtonTapped,
            deleteButtonIsEnable: deleteButtonIsEnable
        )
        
        dataSource = UICollectionViewDiffableDataSource<SettingRoutineSection, SettingRoutineItem>(
            collectionView: settingRoutineCollectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                let section = SettingRoutineSection(rawValue: indexPath.section)
                
                var item: Any?
                switch itemIdentifier {
                case .dayItem(let weekDay):
                    item = weekDay
                case .timeSettingItem:
                    item = nil
                case .recommendRoutineItem(let routine):
                    item = routine
                case .deleteRoutineItem:
                    item = nil
                }
                
                switch section {
                case .dayTime:
                    return collectionView.dequeueConfiguredReusableCell(
                        using: dayCellRegistration,
                        for: indexPath,
                        item: item as? WeekDay
                    )
                case .timeSetting:
                    return collectionView.dequeueConfiguredReusableCell(
                        using: routineSettingCellRegistration,
                        for: indexPath,
                        item: Void()
                    )
                case .recommendRoutine:
                    return collectionView.dequeueConfiguredReusableCell(
                        using: fastRoutineCellRegistration,
                        for: indexPath,
                        item: item as? FastRoutine
                    )
                case .some(.deleteRoutineSetting):
                    return collectionView.dequeueConfiguredReusableCell(
                        using: deleteRoutineCellRegistration,
                        for: indexPath,
                        item: Void()
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
            default:
                view = collectionView.dequeueConfiguredReusableSupplementary(
                    using: titleHeaderRegistration,
                    for: indexPath
                )
            }
            return view
        }
    }
    
    func createDayCellRegistration(selectedDays: BehaviorRelay<[Int]>) -> UICollectionView.CellRegistration<DayCollectionViewCell, WeekDay> {
        return UICollectionView.CellRegistration<DayCollectionViewCell, WeekDay> { [weak self] cell, _, weekDay in
            guard let self else { return }
            let disposeBag = DisposeBag()
            dayCellDisposeBag[cell] = disposeBag
            selectedDays.asDriver()
                .map { $0.contains(weekDay.rawValue) }
                .map { $0 ? Constants.Color.tintBase : Constants.Color.disactive }
                .drive { cell.configureBackgroundColor(with: $0) }
                .disposed(by: disposeBag)
            cell.configureCell(with: weekDay)
        }
    }
    
    func createTimeSettingCellRegistration(
        timePickerViewTapped: PublishRelay<TimePickerViewType>,
        selectedStartTime: BehaviorRelay<DateComponents>,
        selectedFastTime: BehaviorRelay<Int>,
        selectedFastInfo: BehaviorRelay<String>
    ) -> UICollectionView.CellRegistration<TimeSettingCollectionViewCell, Void> {
        return UICollectionView.CellRegistration<TimeSettingCollectionViewCell, Void> { [weak self] cell, _, _ in
            guard let self else { return }
            let disposeBag = DisposeBag()
            timeSettingCellDisposeBag[cell] = disposeBag
            selectedStartTime.asDriver()
                .distinctUntilChanged()
                .map { $0.timeString }
                .drive { cell.configureStartTimeLabel(with: $0) }
                .disposed(by: disposeBag)
            selectedFastTime.asDriver()
                .distinctUntilChanged()
                .map { String(localized: "HOURS", defaultValue: "\($0) 시간" ) }
                .drive { cell.configureFastTimeLabel(with: $0) }
                .disposed(by: disposeBag)
            selectedFastInfo.asDriver()
                .distinctUntilChanged()
                .drive { cell.configureSelectedFastInfoLabel(with: $0) }
                .disposed(by: disposeBag)
                
            cell.timePickerViewTapped = timePickerViewTapped
        }
    }
    
    func createRoutineRecommendCellRegistration(selectedRecommendRoutine: BehaviorRelay<Int?>) -> UICollectionView.CellRegistration<FastRoutineCollectionViewCell, FastRoutine> {
        return UICollectionView.CellRegistration<FastRoutineCollectionViewCell, FastRoutine> { [weak self] cell, indexPath, fastRoutine in
            guard indexPath.section == SettingRoutineSection.recommendRoutine.rawValue
            else {
                assertionFailure("invalid section")
                return
            }
            guard let self else { return }
            let disposeBag = DisposeBag()
            recommendRoutineCellDisposeBag[cell] = disposeBag
            selectedRecommendRoutine.asDriver()
                .distinctUntilChanged()
                .map { $0 == indexPath.item }
                .map { $0 ? Constants.Color.tintBase : Constants.Color.disactive }
                .drive { cell.configureBackgroundColor(with: $0) }
                .disposed(by: disposeBag)
            cell.configureCell(routine: fastRoutine)
        }
    }
    
    func createDeleteRoutineSettingCellRegistration(
        deleteRoutineSettingButtonTapped: PublishRelay<Void>,
        deleteButtonIsEnable: BehaviorRelay<Bool>
    ) -> UICollectionView.CellRegistration<DeleteRoutineSettingCell, Void> {
        return UICollectionView.CellRegistration<DeleteRoutineSettingCell, Void> { [weak self] cell, indexPath, _ in
            guard let self else { return }
            guard indexPath.section == SettingRoutineSection.deleteRoutineSetting.rawValue
            else {
                assertionFailure("invalid section")
                return
            }
            let disposeBag = DisposeBag()
            self.deleteSettingCellDisposeBag[cell] = disposeBag
            cell.deleteRoutineSettingButtonTapped = deleteRoutineSettingButtonTapped
            deleteButtonIsEnable.asDriver()
                .drive { cell.configureDeleteButtonEnable(with: $0) }
                .disposed(by: disposeBag)
        }
    }
    
    func createTitleCollectionHeaderCellRegistration() -> UICollectionView.SupplementaryRegistration<TitleCollectionViewHeader> {
        return UICollectionView.SupplementaryRegistration(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, _, indexPath in
            guard let title = SettingRoutineSection(rawValue: indexPath.section)?.title
            else {
                return
            }
            supplementaryView.configureCell(with: title)
        }
    }
}

extension SettingRoutineViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        shouldSelectItemAt indexPath: IndexPath
    ) -> Bool {
        return indexPath.section == SettingRoutineSection.timeSetting.rawValue || indexPath.section == SettingRoutineSection.deleteRoutineSetting.rawValue
                ? false
                : true
    }
}
