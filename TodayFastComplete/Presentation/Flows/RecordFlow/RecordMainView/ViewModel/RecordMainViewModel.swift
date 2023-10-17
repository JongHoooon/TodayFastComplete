//
//  RecordMainViewModel.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/17/23.
//

import Foundation

final class RecordMainViewModel: ViewModel {
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    private let viewModel: Coordinator
    
    init(coordinator: Coordinator) {
        self.viewModel = coordinator
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
}
