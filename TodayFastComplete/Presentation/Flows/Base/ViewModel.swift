//
//  ViewModel.swift
//  TodayFastComplete
//
//  Created by JongHoon on 9/30/23.
//

import RxSwift

protocol ViewModel: AnyObject {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
