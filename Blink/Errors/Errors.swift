//
//  Errors.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 16.04.25.
//

import Foundation

enum ApiError: Error {
    
    struct ServerError: Error, Decodable {
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
    
    enum AppError : Error {
        case invalidUrl(Error)
        case systemError(Error)
        case noInternetConnection
        case locationIsNotAllowed
        case encoderError
    }
    
    case serverError(ServerError)
    case appError(AppError)
    
}


