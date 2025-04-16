//
//  Decoder.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 17.04.25.
//

import Foundation


struct Response<ReturnType : Codable> : Decodable {
    let data: ReturnType?
    let error: ApiError.ServerError?
    
    static func parse(from data: Data) throws(ApiError) -> ReturnType? {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
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
