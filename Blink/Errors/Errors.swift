//
//  Errors.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 16.04.25.
//

import Foundation

enum ApiError: Error, Equatable {
    
    struct ServerError: Error, Decodable, Equatable {
        let code: Int
        let message: String
        
        enum Errors: Int, CaseIterable {
            case userAlreadyExist = 405
            case userNotFount = 404
            case requestError = 403
            case friendshipNotFound = 402
            case friendNotFound = 401
            case socketError = 400
            case unknown = -1
        }
        
        init(error: Errors) {
            self.code = error.rawValue
            self.message = "error"
        }
        
        var applicationError: Errors? {
            Errors.allCases.first { $0.rawValue == code }
        }
    }
    
    enum AppError : Error, Equatable {
        case invalidUrl
        case systemError
        case noInternetConnection
        case locationIsNotAllowed
        case encoderError
        case notAllFieldsFilled
        case connectionError
    }
    
    case serverError(ServerError)
    case appError(AppError)
    
}

struct ErrorState {
    var errorType: ApiError?
    
    mutating func setError(error: ApiError) {
        self.errorType = error
    }
    
    mutating func clearError() {
        self.errorType = nil
    }
}


