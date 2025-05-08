//
//  ViewState.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 8.05.25.
//

import Foundation


enum ViewState: Equatable {
    case loading
    case error(ApiError)
    case success
}
