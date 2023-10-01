//
//  Log.swift
//  TodayFastComplete
//
//  Created by JongHoon on 10/1/23.
//

import Foundation
import os.log

extension OSLog {
    static let subsystem = Bundle.main.bundleIdentifier ?? ""
    static let debug = OSLog(subsystem: subsystem, category: "Debug")
    static let info = OSLog(subsystem: subsystem, category: "Info")
    static let error = OSLog(subsystem: subsystem, category: "Error")
}

struct Log {
    enum Level {
        case debug
        case info
        case error
        case custom(categoryName: String)
        
        fileprivate var category: String {
            switch self {
            case .debug:                        return "Debug"
            case .info:                         return "Info"
            case .error:                        return "Error"
            case let .custom(categoryName):     return categoryName
            }
        }
        
        fileprivate var osLog: OSLog {
            switch self {
            case .debug:                        return OSLog.debug
            case .info:                         return OSLog.info
            case .error:                        return OSLog.error
            case .custom:                       return OSLog.debug
            }
        }
        
        fileprivate var osLogType: OSLogType {
            switch self {
            case .debug:                        return .debug
            case .info:                         return .info
            case .error:                        return .error
            case .custom:                       return .debug
            }
        }
    }
    
    static private func log(_ message: Any?, level: Level, filename: String, line: Int, funcName: String) {
        #if LOG
        let logger = Logger(subsystem: OSLog.subsystem, category: level.category)
        let filename = filename.components(separatedBy: "/").last ?? ""
        var logMessage = "[\(filename), \(line), \(funcName)]"
        if let message = message {
            logMessage += " - \(message)"
        }
        switch level {
        case .debug, .custom:
            logger.debug("✨ \(logMessage, privacy: .public)")
        case .info:
            logger.info("ℹ️ \(logMessage, privacy: .public)")
        case .error:
            logger.error("🚨 \(logMessage, privacy: .public)")
        }
        #endif
    }
}

extension Log {
    static func debug(_ message: Any?, filename: String = #fileID, line: Int = #line, funcName: String = #function) {
        log(message, level: .debug, filename: filename, line: line, funcName: funcName)
    }
    
    static func info(_ message: Any, filename: String = #fileID, line: Int = #line, funcName: String = #function) {
        log(message, level: .info, filename: filename, line: line, funcName: funcName)
    }
    
    static func error(_ message: Any, filename: String = #fileID, line: Int = #line, funcName: String = #function) {
        log(message, level: .error, filename: filename, line: line, funcName: funcName)
    }
    
    static func custom(category: String, _ message: Any, filename: String = #fileID, line: Int = #line, funcName: String = #function) {
        log(message, level: .custom(categoryName: category), filename: filename, line: line, funcName: funcName)
    }
    
    static func `deinit`(filename: String = #fileID, line: Int = #line, funcName: String = #function) {
        log(nil, level: .info, filename: filename, line: line, funcName: funcName)
    }
}
