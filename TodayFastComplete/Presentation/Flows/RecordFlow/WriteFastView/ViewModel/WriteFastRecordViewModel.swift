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
    
    private let coordinator: Coordinator
    private let disposeBag: DisposeBag
    let startDate: Date
    private var weight: Double
    
    init(
        coordinator: Coordinator,
        startDate: Date
    ) {
        self.coordinator = coordinator
        self.disposeBag = DisposeBag()
        self.startDate = startDate
        self.weight = UserDefaultsManager.recentSavedWeight
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.viewDidLoad
            .map { _ in UserDefaultsManager.routineSetting }
            .bind(with: self, onNext: { owner, setting in
                if let setting {
                    guard let startDate = Calendar.current.date(
                        bySettingHour: setting.startTime.hour ?? 0,
                        minute: setting.startTime.minute ?? 0,
                        second: 0,
                        of: owner.startDate
                    ) else { return }
                    let endDate = startDate.addingTimeInterval(TimeInterval(setting.fastTimeHour*60*60))
                    output.startDatePickerDate.accept(startDate)
                    output.endDatePickerDate.accept(endDate)
                    output.startTimeDate.accept(startDate)
                    output.endTimeDate.accept(endDate)
                } else {
                    output.startDatePickerDate.accept(owner.startDate)
                    output.endDatePickerDate.accept(owner.startDate)
                    output.startTimeDate.accept(owner.startDate)
                    output.endTimeDate.accept(owner.startDate)
                }
            })
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
        .debug()
        .map { $0 < 0 ? 0 : $0 }
        .debug()
        .bind(onNext: { output.totalFastTimeSecond.accept($0) })
        .disposed(by: disposeBag)
        
        input.minusWeightButtonTapped
            .compactMap { [weak self] in (self?.weight ?? 0.0) - 0.1 }
            .map { $0 < 0 ? 0 : $0 }
            .bind(with: self, onNext: { owner, weight in
                output.weight.accept(weight)
                owner.weight = weight
            })
            .disposed(by: disposeBag)
        
        input.plusWeightButtonTapped
            .compactMap { [weak self] in (self?.weight ?? 0.0) + 0.1 }
            .bind(with: self, onNext: { owner, weight in
                output.weight.accept(weight)
                owner.weight = weight
            })
            .disposed(by: disposeBag)
        
        input.weightTextFieldText
            .compactMap { Double($0) }
            .bind(with: self, onNext: { owner, weightText in
                owner.weight = weightText
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
