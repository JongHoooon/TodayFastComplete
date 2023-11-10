//
//  WriteFastRecordViewModel.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/19/23.
//

import Foundation

import RxRelay
import RxSwift

final class WriteFastRecordViewModel: ViewModel {
    
    struct Input { 
        let viewDidLoad: Observable<Void>
        let fastStartTitleViewTapped: Observable<Void>
        let fastEndTitleViewTapped: Observable<Void>
        let dismissButtonTapped: Observable<Void>
        let minusWeightButtonTapped: Observable<Void>
        let plusWeightButtonTapped: Observable<Void>
        let startTimeDate: Observable<Date>
        let endTimeDate: Observable<Date>
        let weightTextFieldText: Observable<String>
        let saveButtonTapped: Observable<Void>
    }
    
    struct Output { 
        let startDatePickerIsShow = BehaviorRelay(value: false)
        let endDatePickerIsShow = BehaviorRelay(value: false)
        let startDatePickerDate = BehaviorRelay(value: Date())
        let endDatePickerDate = BehaviorRelay(value: Date())
        let startTimeDate = BehaviorRelay(value: Date())
        let endTimeDate = BehaviorRelay(value: Date())
        let totalFastTimeSecond = BehaviorRelay(value: 0)
        let weight = BehaviorRelay(value: UserDefaultsManager.recentSavedWeight)
    }
    
    private let fastRecord: FastRecord?
    private let weightRecord: WeightRecord?
    
    private let coordinator: Coordinator
    private let useCase: RecordUseCase
    private let disposeBag: DisposeBag
    let startDate: Date
    private var weightRelay = BehaviorRelay<Double>(value: UserDefaultsManager.recentSavedWeight)
    
    init(
        coordinator: Coordinator,
        useCase: RecordUseCase,
        startDate: Date,
        fastRecord: FastRecord?,
        weightRecord: WeightRecord?
    ) {
        self.coordinator = coordinator
        self.disposeBag = DisposeBag()
        self.startDate = startDate
        self.useCase = useCase
        self.fastRecord = fastRecord
        self.weightRecord = weightRecord
    }
    
    deinit {
        Log.deinit()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()

        let viewDidLoadShared = input.viewDidLoad.share()
        
        viewDidLoadShared
            .compactMap { [weak self] in self?.startDateTime }
            .bind(to: output.startDatePickerDate, output.startTimeDate)
            .disposed(by: disposeBag)
        
        viewDidLoadShared
            .compactMap { [weak self] in self?.endDateTime }
            .bind(to: output.endDatePickerDate, output.endTimeDate)
            .disposed(by: disposeBag)
        
        input.dismissButtonTapped
            .bind(with: self, onNext: { owner, _ in
                owner.coordinator.navigate(to: .writeFastRecordIsComplete)
            })
            .disposed(by: disposeBag)
        
        input.fastStartTitleViewTapped
            .withLatestFrom(output.startDatePickerIsShow)
            .bind(onNext: { output.startDatePickerIsShow.accept(!$0) })
            .disposed(by: disposeBag)
        
        input.fastEndTitleViewTapped
            .withLatestFrom(output.endDatePickerIsShow)
            .bind(onNext: { output.endDatePickerIsShow.accept(!$0) })
            .disposed(by: disposeBag)
        
        let startTimeDateShared = input.startTimeDate.share()
        let endTimeDateShared = input.endTimeDate.share()
        
        startTimeDateShared
            .skip(1)
            .bind { output.startTimeDate.accept($0) }
            .disposed(by: disposeBag)
        
        endTimeDateShared
            .skip(1)
            .bind { output.endTimeDate.accept($0) }
            .disposed(by: disposeBag)
        
        BehaviorRelay.combineLatest(
            output.startTimeDate,
            output.endTimeDate
        )
        .map { Int($0.distance(to: $1)) }
        .map { $0 < 0 ? 0 : $0 }
        .bind(onNext: { output.totalFastTimeSecond.accept($0) })
        .disposed(by: disposeBag)
        
        input.minusWeightButtonTapped
            .withLatestFrom(weightRelay)
            .map { $0 - 0.1 }
            .map { $0 < 0 ? 0 : $0 }
            .bind(with: self, onNext: { owner, weight in
                output.weight.accept(weight)
                owner.weightRelay.accept(weight)
            })
            .disposed(by: disposeBag)
        
        input.plusWeightButtonTapped
            .withLatestFrom(weightRelay)
            .map { $0 + 0.1 }
            .bind(with: self, onNext: { owner, weight in
                output.weight.accept(weight)
                owner.weightRelay.accept(weight)
            })
            .disposed(by: disposeBag)
        
        input.weightTextFieldText
            .skip(1)
            .map { Double($0) ?? 0.0 }
            .bind(with: self, onNext: { owner, weight in
                owner.weightRelay.accept(weight)
            })
            .disposed(by: disposeBag)
        
        input.saveButtonTapped
            .bind { saveButtonTapped() }
            .disposed(by: disposeBag)
            
        return output
        
        func saveButtonTapped() {
            Observable.just(Void())
                .map { try validateRecord() }
                .map { [unowned self] _ -> (FastRecord, WeightRecord?) in
                    let fastRecord = FastRecord(
                        date: startDate,
                        startDate: output.startTimeDate.value,
                        endDate: output.endTimeDate.value
                    )
                    let weight = weightRelay.value
                    switch weight == 0 {
                    case true:
                        return (fastRecord, nil)
                    case false:
                        let weightRecord = WeightRecord(
                            date: startDate,
                            weight: weight
                        )
                        return (fastRecord, weightRecord)
                    }
                }
                .flatMap { [unowned self] in self.useCase.saveRecords(fastRecord: $0.0, weightRecord: $0.1) }
                .observe(on: MainScheduler.instance)
                .subscribe(
                    with: self,
                    onNext: { owner, _ in
                        owner.coordinator.navigate(to: .writeFastRecordIsComplete)
                    },
                    onError: { owner, error in
                        let errorMessage = if let error = error as? RecordValidateError,
                            error == .badFastTime {
                                Constants.Localization.FAST_TIME_VALIDATE_ALERT_MESSAGE
                            } else {
                                error.localizedDescription
                            }
                        owner.coordinator.navigate(to: .writeRecordValidateAlert(
                            title: nil,
                            message: errorMessage
                        ))
                    })
                .disposed(by: disposeBag)
        }
        
        func validateRecord() throws {
            if output.totalFastTimeSecond.value == 0 {
                throw RecordValidateError.badFastTime
            }
        }
    }
}

private extension WriteFastRecordViewModel {
    var startDateTime: Date {
        if let fastRecord = fastRecord {
            return fastRecord.startDate
        }
        
        if let setting = UserDefaultsManager.routineSetting {
            guard let hour = setting.startTime.hour,
                  let minute = setting.startTime.minute
            else {
                assertionFailure("no hour or minute")
                return Date()
            }
            return Calendar.current.date(
                bySettingHour: hour,
                minute: minute,
                second: 0,
                of: startDate
            ) ?? Date()
        } else {
            return startDate
        }
    }
    
    var endDateTime: Date {
        if let fastRecord = fastRecord {
            return fastRecord.endDate
        }
        
        if let setting = UserDefaultsManager.routineSetting {
            return startDateTime.addingTimeInterval(TimeInterval(setting.fastTimeHour * 3600))
        } else {
            return startDate
        }
    }
}
