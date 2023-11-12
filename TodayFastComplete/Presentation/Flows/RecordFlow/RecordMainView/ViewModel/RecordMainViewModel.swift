//
//  RecordMainViewModel.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/17/23.
//

import Foundation

import RxRelay
import RxSwift

final class RecordMainViewModel: ViewModel {
    struct Input {
        let viewDidLoad: Observable<Void>
        let selectedSegmentIndex: Observable<Int>
        let swipeUpGesture: Observable<Void>
        let swipeDownGesture: Observable<Void>
        let calendarDidSelect: Observable<Date>
        let toggleButtonTapped: Observable<Void>
        let beforeButtonTapped: Observable<Void>
        let afterButtonTapped: Observable<Void>
        let calendarCurrentPageDidChange: Observable<Date>
    }
    
    struct Output {
        let currentPage = BehaviorRelay(value: 0)
        let calendarScope = BehaviorRelay(value: 1)
        let dateInfoLabelText = BehaviorRelay(value: Date().toString(format: .yearMonthDayWeekDayFormat))
    }
    
    private weak var coordinator: Coordinator?
    private let recordUseCase: RecordUseCase
    private let calendarformatter = DateFormatter.yearMonthDayFormat
    private let disposeBag: DisposeBag
    
    private let selectedDateRelay: BehaviorRelay<Date>
    private let fastRecordViewState: BehaviorRelay<RecordViewState>
    private let weightRecordViewState: BehaviorRelay<RecordViewState>
    private let editButtonTapped: PublishRelay<Void>
    private let deleteButtonTapped: BehaviorRelay<RecordEnum>
    
    private let fastRecordUpdateRelay: PublishRelay<FastRecord>
    private let weightRecordUpdateRelay: PublishRelay<WeightRecord>
    
    private let deleteRecordRelay: PublishRelay<AlertActionType>
    
    var fastRecordDict: [Date: FastRecord] = [:]
    var weightRecordDict: [Date: WeightRecord] = [:]
    
    init(
        coordinator: Coordinator,
        recordUseCase: RecordUseCase,
        selectedDateRelay: BehaviorRelay<Date>,
        fastRecordViewState: BehaviorRelay<RecordViewState>,
        weightRecordViewState: BehaviorRelay<RecordViewState>,
        editButtonTapped: PublishRelay<Void>,
        deleteButtonTapped: BehaviorRelay<RecordEnum>,
        fastRecordUpdateRelay: PublishRelay<FastRecord>,
        weightRecordUpdateRelay: PublishRelay<WeightRecord>
    ) {
        self.coordinator = coordinator
        self.recordUseCase = recordUseCase
        self.selectedDateRelay = selectedDateRelay
        self.fastRecordViewState = fastRecordViewState
        self.weightRecordViewState = weightRecordViewState
        self.editButtonTapped = editButtonTapped
        self.deleteButtonTapped = deleteButtonTapped
        self.fastRecordUpdateRelay = fastRecordUpdateRelay
        self.weightRecordUpdateRelay = weightRecordUpdateRelay
        self.deleteRecordRelay = PublishRelay()
        self.disposeBag = DisposeBag()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        let viewDidLoadShared = input.viewDidLoad.share()
        
        viewDidLoadShared
            .flatMap { [unowned self] _ in Single.zip(recordUseCase.fetchFastRecords(), recordUseCase.fetchWeightRecords()) }
            .map { fastRecords, weightRecords in
                let fastRecordDict = fastRecords.reduce(into: [:], { dict, record in dict[record.date] = record })
                let weightRecordDict = weightRecords.reduce(into: [:], { dict, record in dict[record.date] = record })
                return (fastRecordDict, weightRecordDict)
            }
            .debug()
            .bind { [weak self] fastRecordDict, weightRecordDict in
                self?.fastRecordDict = fastRecordDict
                self?.weightRecordDict = weightRecordDict
                self?.countRecordViewState(date: Date().toCalendarDate)
            }
            .disposed(by: disposeBag)
        
        input.selectedSegmentIndex
            .bind { output.currentPage.accept($0) }
            .disposed(by: disposeBag)
        
        /*
         FSCalendarScope enum month raw value:  0
         FSCalendarScope enum week raw value:   1
         */
        input.swipeUpGesture
            .map { 1 }
            .bind { output.calendarScope.accept($0) }
            .disposed(by: disposeBag)
        
        input.swipeDownGesture
            .map { 0 }
            .bind { output.calendarScope.accept($0) }
            .disposed(by: disposeBag)
        
        input.toggleButtonTapped
            .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.asyncInstance)
            .map { _ in output.calendarScope.value == 1 ? 0 : 1 }
            .bind { output.calendarScope.accept($0) }
            .disposed(by: disposeBag)
        
        let calendarDidSelectShared = input.calendarDidSelect.share()
        
        calendarDidSelectShared
            .map { $0.toString(format: .yearMonthDayWeekDayFormat) }
            .bind(to: output.dateInfoLabelText)
            .disposed(by: disposeBag)
        
        calendarDidSelectShared
            .bind(to: selectedDateRelay)
            .disposed(by: disposeBag)
        
        calendarDidSelectShared
            .bind(with: self, onNext: { owner, date in
                owner.countRecordViewState(date: date)
            })
            .disposed(by: disposeBag)
        
        input.calendarCurrentPageDidChange
            .map(\.month)
            .distinctUntilChanged()
            .bind {
                print($0)
//                print($0.month)
            }
            .disposed(by: disposeBag)
        
        editButtonTapped
            .map { [unowned self] in
                let startDate = selectedDateRelay.value
                return Step.writeFastRecord(
                    startDate: startDate,
                    fastRecor: fastRecordDict[startDate],
                    weightRecord: weightRecordDict[startDate]
                )
            }
            .observe(on: MainScheduler.instance)
            .bind { [weak self] in self?.coordinator?.navigate(to: $0) }
            .disposed(by: disposeBag)
        
        deleteButtonTapped
            .skip(1)
            .bind(with: self, onNext: { owner, record in
                owner.coordinator?.navigate(to: .recordDeleteAlert(
                    record: record,
                    deleteAlertRelay: owner.deleteRecordRelay
                )
            )})
            .disposed(by: disposeBag)
        
        deleteRecordRelay
            .filter { $0 == .ok }
            .withLatestFrom(deleteButtonTapped)
            .flatMap { [unowned self] record in
                return switch record {
                case .fast:
                    self.recordUseCase.deleteFastRecord(date: selectedDateRelay.value)
                        .map { _ in record }
                case .weight:
                    self.recordUseCase.deleteWeightRecrod(date: selectedDateRelay.value)
                        .map { _ in record }
                }
            }
            .subscribe(
                with: self,
                onNext: { owner, record in
                    switch record {
                    case .fast:
                        owner.fastRecordDict.removeValue(forKey: owner.selectedDateRelay.value)
                        owner.fastRecordViewState.accept(.noRecord)
                    case .weight:
                        owner.weightRecordDict.removeValue(forKey: owner.selectedDateRelay.value)
                        owner.weightRecordViewState.accept(.noRecord)
                    }
                },
                onError: { _, error in
                    Log.error(error)
                })
            .disposed(by: disposeBag)
        
        fastRecordUpdateRelay
            .flatMap { [unowned self] record in
                self.recordUseCase.updateFastRecord(record: record)
                    .map { _ in record }
            }
            .subscribe(
                with: self,
                onNext: { owner, record in
                    owner.fastRecordDict[record.date] = record
                    owner.fastRecordViewState.accept(.recordExist(record: record))
                },
                onError: { _, error in
                    Log.error(error)
                })
            .disposed(by: disposeBag)
        
        weightRecordUpdateRelay
            .flatMap { [unowned self] record in
                self.recordUseCase.updateWeightRecord(record: record)
                    .map { _ in record }
            }
            .subscribe(
                with: self,
                onNext: { owner, record in
                    owner.weightRecordDict[record.date] = record
                    owner.weightRecordViewState.accept(.recordExist(record: record))
                },
                onError: { _, error in
                    Log.error(error)
                })
            .disposed(by: disposeBag)
            
        return output
    }
}

private extension RecordMainViewModel {
    func countRecordViewState(date: Date) {
        if Date().toCalendarDate < date {
            fastRecordViewState.accept(.cantRecord)
            weightRecordViewState.accept(.cantRecord)
            return
        }
        
        if let fastRecord = fastRecordDict[date] {
            fastRecordViewState.accept(.recordExist(record: fastRecord))
        } else {
            fastRecordViewState.accept(.noRecord)
        }
        
        if let weightRecord = weightRecordDict[date] {
            weightRecordViewState.accept(.recordExist(record: weightRecord))
        } else {
            weightRecordViewState.accept(.noRecord)
        }
    }
}
