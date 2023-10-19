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
    
    private let calendarButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 12.0
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
        label.text = "2023년 10월 18일 수요일"
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
        return segmentedControl
    }()

    var currentPage: Int = 0 {
        // segment control -> pageView controller 업데이트
        didSet {
            let direction: UIPageViewController.NavigationDirection = oldValue <= self.currentPage
                ? .forward
                : .reverse
            recordPageViewController.setViewControllers(
                [pageViewChildViewControllers[currentPage]],
                direction: direction,
                animated: true,
                completion: nil
            )
        }
    }
    
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
            $0.top.equalTo(calendarView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        calendarButtonStackView.snp.makeConstraints {
            $0.centerY.equalTo(calendarView.calendarHeaderView.snp.centerY)
            $0.trailing.equalToSuperview().inset(16.0)
            $0.height.equalTo(28.0)
        }
        
        grabberView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(4.0)
            $0.width.equalTo(56.0)
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
        
        let swipeDown = UISwipeGestureRecognizer()
        swipeDown.direction = .down
        let swipeUp = UISwipeGestureRecognizer()
        swipeUp.direction = .up
        [
            swipeUp,
            swipeDown
        ].forEach {
            view.addGestureRecognizer($0)
//            calendarView.addGestureRecognizer($0)
        }
        
        swipeDown.rx.event
            .subscribe(with: self, onNext: { owner, _ in
                owner.calendarView.setScope(.month, animated: true)
            })
            .disposed(by: disposeBag)
        
        swipeUp.rx.event
            .subscribe(with: self, onNext: { owner, _ in
                owner.calendarView.setScope(.week, animated: true)
            })
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
        
        calendarView.rx.didSelect
            .asDriver(onErrorJustReturn: Date())
            .drive(with: self, onNext: { owner, date in
                print(date, date.toString(format: .dateTimeFormat))
            })
            .disposed(by: disposeBag)
        
        calendarView.rx.willDisplay
            .observe(on: MainScheduler.asyncInstance)
            .bind(onNext: { cell, date in
                guard let cell = cell as? FSCalendarCustomCell else { return }
                cell.configureCell(date: date)
            })
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
                .font: UIFont.custom(size: 14.0, weight: .light)
            ],
            for: .normal
        )
        segmentedControl.setTitleTextAttributes(
            [
                .foregroundColor: UIColor.label,
                .font: UIFont.custom(size: 14.0, weight: .medium)
            ],
            for: .selected
        )
        
        segmentedControl.addTarget(self, action: #selector(changeValue(control:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        changeValue(control: segmentedControl)
    }
    
    @objc
    private func changeValue(control: UISegmentedControl) {
        currentPage = control.selectedSegmentIndex
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
}
