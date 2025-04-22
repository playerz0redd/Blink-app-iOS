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
                    return "Ошибка запроса"
                case .userAlreadyExist:
                    return "Пользователь существует"
                case .unknown, .none:
                    return "Неизвестная ошибка сервера"
                case .some(.socketError):
                    return "Неизвестная ошибка сервера"
                }
                
            case .appError(let appError):
                switch appError {
                case .invalidUrl:
                    return "Неверный URL"
                case .systemError(let sysError):
                    return "Системная ошибка: \(sysError.localizedDescription)"
                case .noInternetConnection:
                    return "Нет соединения с интернетом"
                case .locationIsNotAllowed:
                    return "Нет прав для работы с вашей геолокацией"
                case .encoderError:
                    return "Неизвестная ошибка сервера"
                }
            }
    }
}
