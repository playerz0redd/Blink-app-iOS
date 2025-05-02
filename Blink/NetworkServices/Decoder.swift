//
//  Decoder.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 17.04.25.
//

import Foundation


struct Response<ReturnType : Decodable> : Decodable {
    let data: ReturnType?
    let error: ApiError.ServerError?
    
    static func parse(from data: Data) throws(ApiError) -> ReturnType? {
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        do {
            print(ReturnType.self)
            let convertedData = try decoder.decode(Response.self, from: data)
            
            if let data = convertedData.data {
                return data
            }
            
            if let error = convertedData.error {
                throw ApiError.serverError(error)
            }
            
        } catch {
            throw .appError(.systemError(error))
        }
        return nil
    }
    
}
