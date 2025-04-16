//
//  NetworkManager.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 16.04.25.
//

import Foundation

class NetworkManager2 {
    
    enum RequestMethod : String {
        case get = "GET"
        case post = "POST"
    }
    
    private let serverIP = "http://127.0.0.1:8000"
    
    func sendRequest<ApiData: Codable>(
        url: String,
        method: RequestMethod,
        requestData: ApiData?) async throws(ApiError) -> Data? {
            
            // config url with call
            let url = URL(string: serverIP + url)!
            
            let jsonData = try? JSONEncoder().encode(requestData)
        
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            var (data, response) : (Data?, URLResponse?) = (nil, nil)
            
            do {
                (data, response) = try await URLSession.shared.data(for: request)
            } catch {
                throw .appError(.systemError(error))
            }
            
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    throw ApiError.serverError(.init(error: ApiError.ServerError.Errors(rawValue: response.statusCode) ?? .unknown))
                }
            }
            
            return data
    }
}
