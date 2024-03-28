//
//  CountriesRequesting.swift
//  CountriesList-UIKit
//
//  Created by Coleton Gorecke on 3/26/24.
//

import Foundation

protocol CountriesRequesting {
    func fetchCountries() async throws -> [CountryDTO]
}

final class CountriesRequestor: NetworkRequesting, CountriesRequesting {
    func fetchCountries() async throws -> [CountryDTO] {
        do {
            print("Attempting to fetch countries")
            return try await performRequest(CountriesRequest())
        } catch {
            print("Failed to fetch countries with error: \(error)")
            throw error
        }
    }
}
