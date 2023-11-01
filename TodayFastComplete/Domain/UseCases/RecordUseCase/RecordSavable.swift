//
//  RecordSavable.swift
//  TodayFastComplete
//
//  Created by JongHoon on 11/1/23.
//

import Foundation

import RxSwift

protocol RecordsSavable {
    func saveRecords(fastRecord: FastRecord, weightRecord: WeightRecord?) -> Single<(FastRecord, WeightRecord?)>
}
