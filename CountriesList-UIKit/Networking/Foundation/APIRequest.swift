//
//  APIRequest.swift
//  CountriesList-UIKit
//
//  Created by Coleton Gorecke on 3/26/24.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

/// The protocol request objects must conform too.
protocol APIRequest {
    associatedtype Response: Decodable
    
    var method: HTTPMethod { get }
    var headers: [APIHeader] { get }
    
    func urlRequest(with body: Data?) throws -> URLRequest
}

extension APIRequest {
    
    var headers: [APIHeader] {
        [APIHeader.contentType]
    }
    
    func urlRequest(with body: Data? = nil) throws -> URLRequest {
        let urlString = APIConstants.urlString
        guard let url = URL(string: urlString) else {
            let logStr = "Failed to build url from: \(urlString)"
            print(logStr)
            throw APIError.invalidURL(details: logStr)
        }
        
        print("URL: \(urlString)")
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        print("HTTPMethod: \(method.rawValue)")
        headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        return request
    }
}
