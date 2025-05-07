//
//  ApiErrorExtensions.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 17.04.25.
//

import Foundation

extension ApiError {
    func returnErrorMessage() -> String {
        switch self {
            case .serverError(let serverError):
                switch serverError.applicationError {
                case .userNotFount:
                    return "Пользователь не найден"
                case .friendNotFound:
                    return "Друг не найден"
                case .friendshipNotFound:
                    return "Дружба не найдена"
                case .requestError:
                    return "Ошибка соединения"
                case .userAlreadyExist:
                    return "Пользователь существует"
                case .unknown, .none:
                    return "Ошибка соединения"
                case .socketError:
                    return "Ошибка соединения"
                }
            
                
            case .appError(let appError):
                switch appError {
                case .invalidUrl:
                    return "Неверный URL"
                case .systemError:
                    return "Системная ошибка"
                case .noInternetConnection:
                    return "Нет соединения с интернетом"
                case .locationIsNotAllowed:
                    return "Нет прав для работы с вашей геолокацией"
                case .encoderError:
                    return "Системная ошибка"
                case .notAllFieldsFilled:
                    return "Не все поля заполнены"
                case .connectionError:
                    return "Ошибка соединения"
                }
            }
    }
}
