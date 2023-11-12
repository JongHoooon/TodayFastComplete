//
//  FastRecordViewModel.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/19/23.
//

import Foundation

import RxRelay
import RxSwift

final class FastRecordViewModel: ViewModel {
    
    struct Input { 
        let plusViewTapped: Observable<Void>
        let editButtonTapped: Observable<Void>
        let deleteButtonTapped: Observable<Void>
    }
    struct Output {
        let plusViewIsHidden = BehaviorRelay(value: true)
        let recordViewIsHidden = BehaviorRelay(value: true)
        let cantRecordLabelIsHidden = BehaviorRelay(value: true)
        let fastStartTime = BehaviorRelay(value: Date())
        let fastEndTime = BehaviorRelay(value: Date())
        let fastTimeText = BehaviorRelay(value: "")
    }
    
    private weak var coordinator: Coordinator?
    private let disposeBag: DisposeBag
    
    private let selectedDateRelay: BehaviorRelay<Date>
    private let fastRecordViewState: BehaviorRelay<RecordViewState>
    private let editButtonTapped: PublishRelay<Void>
    private let deleteButtonTapped: BehaviorRelay<RecordEnum>
    
    init(
        coordinator: Coordinator,
        selectedDateRelay: BehaviorRelay<Date>,
        fastRecordViewState: BehaviorRelay<RecordViewState>,
        editButtonTapped: PublishRelay<Void>,
        deleteButtonTapped: BehaviorRelay<RecordEnum>
    ) {
        self.coordinator = coordinator
        self.disposeBag = DisposeBag()
        self.selectedDateRelay = selectedDateRelay
        self.fastRecordViewState = fastRecordViewState
        self.editButtonTapped = editButtonTapped
        self.deleteButtonTapped = deleteButtonTapped
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        let fastRecordViewStateShared = fastRecordViewState.share()
        
        fastRecordViewStateShared
            .bind(with: self, onNext: { owner, state in
                guard case let RecordViewState.recordExist(record) = state,
                      let record = record as? FastRecord
                else { return }
                output.fastStartTime.accept(record.startDate)
                output.fastEndTime.accept(record.endDate)
                let timeInterval = record.startDate.distance(to: record.endDate)
                let timeText = owner.secondToFastTimeText(second: timeInterval)
                output.fastTimeText.accept(timeText)
            })
            .disposed(by: disposeBag)
 
        fastRecordViewStateShared
            .map { state in
                return switch state {
                case .cantRecord:       (true, true, false)
                case .recordExist:      (true, false, true)
                case .noRecord:         (false, true, true)
                }
            }
            .bind {
                output.plusViewIsHidden.accept($0.0)
                output.recordViewIsHidden.accept($0.1)
                output.cantRecordLabelIsHidden.accept($0.2)
            }
            .disposed(by: disposeBag)
        
        input.plusViewTapped
            .throttle(
                .milliseconds(500),
                latest: false,
                scheduler: MainScheduler.asyncInstance
            )
            .observe(on: MainScheduler.instance)
            .map { [unowned self] in Step.writeFastRecord(startDate: selectedDateRelay.value) }
            .bind { [unowned self] in coordinator?.navigate(to: $0) }
            .disposed(by: disposeBag)
        
        input.editButtonTapped
            .bind(to: editButtonTapped)
            .disposed(by: disposeBag)
        
        input.deleteButtonTapped
            .map { RecordEnum.fast }
            .bind(to: deleteButtonTapped)
            .disposed(by: disposeBag)
        
        return output
    }
}

private extension FastRecordViewModel {
    func secondToFastTimeText(second: TimeInterval) -> String {
        let second = Int(second)
        let hour = second / 3600
        let minute = (second % 3600) / 60
        var text = ""
        if hour == 0 && minute == 0 { return "0 \(Constants.Localization.HOUR)" }
        if hour != 0 { text += "\(hour) \(Constants.Localization.HOUR) " }
        if minute != 0 { text += "\(minute) \(Constants.Localization.MINUTE)" }
        return text
    }
}
