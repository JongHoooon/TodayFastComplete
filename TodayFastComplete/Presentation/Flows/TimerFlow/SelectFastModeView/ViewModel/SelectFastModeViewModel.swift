//
//  SelectFastModeViewModel.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/5/23.
//

import Foundation

import RxSwift

final class SelectFastModeViewModel: ViewModel {
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    private var coordinator: Coordinator
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    func transform(
        input: Input,
        disposeBag: DisposeBag
    ) -> Output {
        let output = Output()
        return output
    }
}
