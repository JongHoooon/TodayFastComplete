//
//  RecordMainViewController.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/17/23.
//

import UIKit

import FSCalendar
import RxCocoa
import RxSwift

final class RecordMainViewController: BaseViewController {
    
    // MARK: - Property
    private let viewModel: RecordMainViewModel
    private let disposeBag: DisposeBag
    private var isDown = true
    
    // MARK: - UI
    private let recordPageViewController: UIPageViewController
    private let pageViewChildViewControllers: [UIViewController]
    
    private let calendarView: FSCalendar = {
        let calendar = FSCalendar()
        calendar.register(FSCalendarCustomCell.self, forCellReuseIdentifier: FSCalendarCustomCell.identifier)
        calendar.select(Date())
        calendar.appearance.headerTitleColor = .clear
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.appearance.selectionColor = .white
        calendar.appearance.titleSelectionColor = .tintAccent
        calendar.appearance.subtitleSelectionColor = .tintAccent
        calendar.appearance.titleTodayColor = .black
        calendar.appearance.titleDefaultColor = .white
        calendar.appearance.weekdayTextColor = .white
        calendar.appearance.weekdayFont = .custom(size: 14.0, weight: .regular)
        calendar.appearance.titleFont = .custom(size: 14.0, weight: .medium)
        calendar.appearance.subtitleFont = .custom(size: 10.0, weight: .regular)
        calendar.appearance.eventOffset = CGPoint(x: 0, y: -32.0)
        calendar.placeholderType = .none
        calendar.scrollEnabled = true
        calendar.scrollDirection = .horizontal
        calendar.scope = .week
        if let locale = Calendar.current.locale {
            calendar.locale = locale
        }
        calendar.firstWeekday = 2
        return calendar
    }()
    
    private let calendarDateInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "2023년 10월 3주차"
        label.font = .bodyMedium
        label.textColor = .white
        return label
    }()
    
    private let calendarButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 16.0
        return stackView
    }()
    private let toggleButton: UIButton = {
        let button = UIButton()
        button.configuration = UIButton.Configuration.filled()
        button.configuration?.title = "주"
        button.configuration?.image = Constants.Icon.arrowtriagleDownFill?.applyingSymbolConfiguration(.init(pointSize: 8.0))?
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        button.configuration?.baseBackgroundColor = .white
        button.configuration?.baseForegroundColor = .black
        button.configuration?.cornerStyle = .large
        button.configuration?.imagePlacement = .trailing
        button.configuration?.imagePadding = 6.0
        return button
    }()
    private let beforeButon: UIButton = {
        let button = UIButton()
        button.setImage(Constants.Icon.chevronLeft, for: .normal)
        button.tintColor = .white
        return button
    }()
    private let afterButon: UIButton = {
        let button = UIButton()
        button.setImage(Constants.Icon.chevronRight, for: .normal)
        button.tintColor = .white
        return button
    }()
        
    private let baseView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Color.backgroundMain
        view.layer.cornerRadius = 20.0
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.masksToBounds = true
        return view
    }()
    private let grabberView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray.withAlphaComponent(0.4)
        view.layer.cornerRadius = 2.0
        view.clipsToBounds = true
        return view
    }()
    
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4.0
        return stackView
    }()
    private let dateInfoLabel: UILabel = {
        let label = UILabel()
        label.font = .subtitleBold
        label.textColor = .label
        label.text = "2023년 10월 19일 목요일"
        return label
    }()
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyRegural
        label.textColor = .systemGray
        label.text = "단식 29일차, 누적 단식 시간 299시간 🔥"
        return label
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UnderlineSegmentContorl(items: [
            Constants.Localization.FAST_TITLE,
            Constants.Localization.WEIGHT_TITLE
        ])
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()
    
    private let swipeDownGesture: UISwipeGestureRecognizer = {
        let gesture = UISwipeGestureRecognizer()
        gesture.direction = .down
        return gesture
    }()
    
    private let swipeUpGesture: UISwipeGestureRecognizer = {
        let gesture = UISwipeGestureRecognizer()
        gesture.direction = .up
        return gesture
    }()
    
    private let swipeLeftGesture: UISwipeGestureRecognizer = {
        let gesture = UISwipeGestureRecognizer()
        gesture.direction = .left
        return gesture
    }()
    
    private let swipeRightGesture: UISwipeGestureRecognizer = {
        let gesture = UISwipeGestureRecognizer()
        gesture.direction = .right
        return gesture
    }()
    
    // MARK: - Lifecycle
    init(
        viewModel: RecordMainViewModel,
        pageViewController: UIPageViewController,
        pageViewChildViewControllers: [UIViewController]
    ) {
        self.viewModel = viewModel
        self.recordPageViewController = pageViewController
        self.pageViewChildViewControllers = pageViewChildViewControllers
        self.disposeBag = DisposeBag()
        super.init(nibName: nil, bundle: nil)
        baseView.addSubview(recordPageViewController.view)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.layoutIfNeeded()
    }
    
    override func configure() {
        view.backgroundColor = Constants.Color.tintAccent
        configurePageViewController()
        configureSegmentController()
        addGesture()
        calendarView.dataSource = self
        bindViewModel()
    }
    
    override func configureNavigationBar() {
        navigationItem.title = Constants.Localization.RECORD_TITLE
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    override func configureLayout() {
        [
            beforeButon,
            afterButon,
            toggleButton
        ].forEach { calendarButtonStackView.addArrangedSubview($0) }
        
        [
            dateInfoLabel,
            infoLabel
        ].forEach { infoStackView.addArrangedSubview($0) }
        
        [
            grabberView,
            infoStackView,
            segmentedControl,
            recordPageViewController.view
        ].forEach { baseView.addSubview($0) }
        
        [
            calendarView,
            calendarButtonStackView,
            calendarDateInfoLabel,
            baseView
        ].forEach { view.addSubview($0) }
        
        calendarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(300.0)
        }
        toggleButton.snp.makeConstraints {
            $0.height.equalTo(28.0)
            $0.width.equalTo(60.0)
        }
        
        baseView.snp.makeConstraints {
            $0.top.equalTo(calendarView.snp.bottom).offset(16.0)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        calendarButtonStackView.snp.makeConstraints {
            $0.centerY.equalTo(calendarView.calendarHeaderView.snp.centerY)
            $0.trailing.equalToSuperview().inset(16.0)
            $0.height.equalTo(28.0)
        }
        
        calendarDateInfoLabel.snp.makeConstraints {
            $0.centerY.equalTo(calendarButtonStackView)
            $0.leading.equalToSuperview().inset(16.0)
        }
        
        grabberView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(4.0)
            $0.width.equalTo(48.0)
            $0.top.equalToSuperview().inset(8.0)
        }
        
        infoStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24.0)
            $0.leading.equalToSuperview().inset(20.0)
        }
        
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(infoStackView.snp.bottom).offset(4.0)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(36.0)
        }
        
        recordPageViewController.view.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(4.0)
            $0.top.equalTo(segmentedControl.snp.bottom).offset(4.0)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

private extension RecordMainViewController {
    func bindViewModel() {
        let selectedSegmentIndex = Observable.merge(
            swipeRightGesture.rx.event.map { _ in 0 },
            swipeLeftGesture.rx.event.map { _ in 1 },
            segmentedControl.rx.selectedSegmentIndex.asObservable()
        )
        let viewDidLoadShared = self.rx.viewDidLoad
        let calendarCurrentPageDidChangeShared = calendarView.rx.calendarCurrentPageDidChange.share()
        
        let input = RecordMainViewModel.Input(
            selectedSegmentIndex: selectedSegmentIndex,
            swipeUpGesture: swipeUpGesture.rx.event.asObservable().map { _ in },
            swipeDownGesture: swipeDownGesture.rx.event.asObservable().map { _ in },
            calendarDidSelect: calendarView.rx.didSelect, 
            toggleButtonTapped: toggleButton.rx.tap.asObservable(),
            beforeButtonTapped: beforeButon.rx.tap.asObservable().map { _ in },
            afterButtonTapped: afterButon.rx.tap.asObservable().map { _ in }
        )
        
        let output = viewModel.transform(input: input)
        
        output.currentPage
            .withPrevious(startWith: 0)
            .bind(with: self, onNext: { owner, pages in
                let oldPage = pages.0
                let currentPage = pages.1
                let direction: UIPageViewController.NavigationDirection = oldPage <= currentPage
                    ? .forward
                    : .reverse
                owner.recordPageViewController.setViewControllers(
                    [owner.pageViewChildViewControllers[currentPage]],
                    direction: direction,
                    animated: true
            )})
            .disposed(by: disposeBag)
        
        let calendarScopeShared = output.calendarScope
            .map { UInt($0) }
            .compactMap { FSCalendarScope(rawValue: $0) }
            .asDriver(onErrorJustReturn: .week)
        
        calendarScopeShared
            .drive(with: self, onNext: { owner, scope in
                owner.calendarView.setScope(scope, animated: true)
            })
            .disposed(by: disposeBag)
        
        calendarScopeShared
            .map {
                return switch $0 {
                case .month:        Constants.Localization.MONTH
                case .week:         Constants.Localization.WEEK
                default:            Constants.Localization.WEEK
                }
            }
            .skip(1)
            .drive(with: self, onNext: { owner, scopeName in
                owner.toggleButton.configuration?.title = scopeName
                owner.rotateChevronImage()
            })
            .disposed(by: disposeBag)
        
        output.dateInfoLabelText
            .asDriver()
            .drive(dateInfoLabel.rx.text)
            .disposed(by: disposeBag)
        
        calendarView.rx.boundingRectWillChange
            .asDriver(onErrorJustReturn: .zero)
            .drive(with: self, onNext: { owner, bounds in
                owner.calendarView.snp.updateConstraints {
                    $0.height.equalTo(bounds.height)
                }
                UIView.animate(withDuration: 0.5) {
                    owner.view.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
        
        calendarView.rx.willDisplay
            .observe(on: MainScheduler.asyncInstance)
            .bind(onNext: { cell, date in
                guard let cell = cell as? FSCalendarCustomCell else { return }
//                cell.configureCell(date: date)
            })
            .disposed(by: disposeBag)
        
        Driver.merge(
            viewDidLoadShared.asDriver(),
            calendarView.rx.calendarCurrentPageDidChange.map { _ in }.asDriver(onErrorJustReturn: Void())
        )
        .compactMap { [weak self] _ in
            self?.calendarView.currentPage.toString(format: .yearMonthFormat)
        }
        .distinctUntilChanged()
        .drive(calendarDateInfoLabel.rx.text)
        .disposed(by: disposeBag)
        
        beforeButon.rx.tap.asDriver()
            .drive(with: self, onNext: { owner, _ in
                switch owner.calendarView.scope {
                case .week:
                    owner.calendarView.setCurrentPage(
                        owner.calendarView.currentPage.previousWeek,
                        animated: true
                    )
                case .month:
                    owner.calendarView.setCurrentPage(
                        owner.calendarView.currentPage.previousMonth,
                        animated: true
                    )
                @unknown default:
                    return
                }
            })
            .disposed(by: disposeBag)
        
        afterButon.rx.tap.asDriver()
            .drive(with: self, onNext: { owner, _ in
                switch owner.calendarView.scope {
                case .week:
                    owner.calendarView.setCurrentPage(
                        owner.calendarView.currentPage.nextWeek,
                        animated: true
                    )
                case .month:
                    owner.calendarView.setCurrentPage(
                        owner.calendarView.currentPage.nextMonth,
                        animated: true
                    )
                @unknown default:
                    return
                }
            })
            .disposed(by: disposeBag)
        
        swipeRightGesture.rx.event
            .map { _ in 0 }
            .bind(to: segmentedControl.rx.selectedSegmentIndex)
            .disposed(by: disposeBag)
        
        swipeLeftGesture.rx.event
            .map { _ in 1 }
            .bind(to: segmentedControl.rx.selectedSegmentIndex)
            .disposed(by: disposeBag)
    }
}

extension RecordMainViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let index = pageViewChildViewControllers.firstIndex(of: viewController),
              index - 1 >= 0
        else { return nil }
        return pageViewChildViewControllers[index-1]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let index = pageViewChildViewControllers.firstIndex(of: viewController),
              index < pageViewChildViewControllers.count - 1
        else { return nil }
        return pageViewChildViewControllers[index+1]
    }
}

extension RecordMainViewController: FSCalendarDataSource {
    func calendar(
        _ calendar: FSCalendar,
        cellFor date: Date,
        at position: FSCalendarMonthPosition
    ) -> FSCalendarCell {
        return calendar.dequeueReusableCell(
            withIdentifier: FSCalendarCustomCell.identifier,
            for: date,
            at: position
        )
    }
}

private extension RecordMainViewController {
    func configureSegmentController() {
        
        segmentedControl.setTitleTextAttributes(
            [
                .foregroundColor: UIColor.systemGray,
                .font: UIFont.custom(size: 16.0, weight: .medium)
            ],
            for: .normal
        )
        segmentedControl.setTitleTextAttributes(
            [
                .foregroundColor: UIColor.label,
                .font: UIFont.custom(size: 16.0, weight: .bold)
            ],
            for: .selected
        )
    }
    func configurePageViewController() {
        recordPageViewController.setViewControllers(
            [pageViewChildViewControllers[0]],
            direction: .forward,
            animated: true
        )
        recordPageViewController.dataSource = self
        recordPageViewController.view.subviews.forEach {
            if let subview = $0 as? UIScrollView {
                subview.isScrollEnabled = false
            }
        }
    }
    func addGesture() {
        [
            swipeUpGesture,
            swipeDownGesture
        ].forEach { view.addGestureRecognizer($0) }
        [
            swipeRightGesture,
            swipeLeftGesture
        ].forEach { baseView.addGestureRecognizer($0) }
    }
    
    func rotateChevronImage() {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.fromValue = isDown ? 0.0 : CGFloat.pi
        rotateAnimation.toValue = isDown ? CGFloat.pi : CGFloat.pi * 2.0
        rotateAnimation.duration = 0.2
        rotateAnimation.fillMode = .forwards
        rotateAnimation.isRemovedOnCompletion = false
        toggleButton.imageView?.layer.add(rotateAnimation, forKey: nil)
        isDown.toggle()
    }
}
