//
//  LocalRepositoryError.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/10/23.
//

enum LocalRepositoryError: Error {
    case noData(message: String? = nil)
    
    var message: String {
        switch self {
        case let .noData(message):
            return "\(String(describing: message)) is not exist"
        }
    }
}
