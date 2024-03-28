//
//  APIError.swift
//  CountriesList-UIKit
//
//  Created by Coleton Gorecke on 3/26/24.
//

import Foundation

public enum APIError: Error {
    case invalidURL(details: String)
    case decodingError(details: String)
    case encodingError(details: String)
    case httpError(details: String)
    case unknown(details: String)
    case nilValue(details: String)
    
    public var errorDetail: String {
        switch self {
        case .invalidURL(let details),
                .decodingError(let details),
                .encodingError(let details),
                .httpError(details: let details),
                .unknown(let details),
                .nilValue(let details):
            return details
        }
    }
}
