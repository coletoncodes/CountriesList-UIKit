//
//  NetworkRequesting.swift
//  CountriesList-UIKit
//
//  Created by Coleton Gorecke on 3/26/24.
//

import Foundation

protocol NetworkRequesting {
    func performRequest<T: Decodable, U: APIRequest>(_ request: U) async throws -> T
}

extension NetworkRequesting {
    /// The standard decoder.
    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
    
    func performRequest<T: Decodable, U: APIRequest>(_ request: U) async throws -> T {
        let (responseData, response) = try await URLSession.shared.data(for: request.urlRequest(with: nil))
        try handle(response)
        return try decoder.decode(T.self, from: responseData)
    }
    
    // MARK: - Helpers
    private func handle(_ response: URLResponse) throws {
        if let httpResponse = response as? HTTPURLResponse {
            switch httpResponse.statusCode {
            case 200...299:
                print("Status Code: \(httpResponse.statusCode)")
            default:
                let logStr = "Received status code: \(httpResponse.statusCode)"
                print(logStr)
                throw APIError.httpError(details: logStr)
            }
        } else {
            print("Failed to cast response as HTTPURLResponse")
            throw APIError.unknown(details: "Failed to cast response as HTTPURLResponse. Response: \(response)")
        }
    }
}
