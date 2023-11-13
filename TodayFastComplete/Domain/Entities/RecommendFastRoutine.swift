//
//  RecommendFastRoutine.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/8/23.
//

enum RecommendFastRoutine: CaseIterable {
    case fastTime16
    case fastTime12
    case fastTime23
    
    var fastRoutine: FastRoutine {
        switch self {
        case .fastTime16:
            FastRoutine(fastingTime: 16, mealCount: 2, image: Constants.Imgage.fasting)
        case .fastTime12:
            FastRoutine(fastingTime: 12, mealCount: 3)
        case .fastTime23:
            FastRoutine(fastingTime: 23, mealCount: 1)
        }
    }
}
