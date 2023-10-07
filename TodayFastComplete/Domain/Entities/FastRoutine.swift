//
//  FastRoutine.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/6/23.
//

struct FastRoutine: Hashable {
    let fastingTime: Int
    let mealTime: Int
    let mealCount: Int?
    
    init(fastingTime: Int, mealCount: Int? = nil) {
        self.fastingTime = fastingTime
        self.mealTime = 24 - fastingTime
        self.mealCount = mealCount
    }
    
    private var mealCountInfo: String {
        guard let mealCount = mealCount else {
            assertionFailure("meal count not exit")
            return "(1일 3식)"
        }
        return String(
            localized: "MEAL_COUNT_INFO",
            defaultValue: " (1일 \(mealCount)식)"
        )
    }
    
    var routineTitle: String {
        var title = String(
            localized: "ROUTINE_TITLE",
            defaultValue: "\(fastingTime):\(mealTime) 단식"
        )
        if let _ = mealCount {
            title += mealCountInfo
        }
        return title
    }
    
    var routineInfo: String {
        return """
        \(fastingTime) 시간 동안 단식하고
        \(mealTime) 시간 동안 식사하기
        """
    }
}
