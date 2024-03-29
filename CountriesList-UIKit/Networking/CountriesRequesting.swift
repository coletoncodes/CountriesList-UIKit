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
    
    private var cachedCountries: [CountryDTO]? = nil
    
    func fetchCountries() async throws -> [CountryDTO] {
        if let cachedCountries {
            return cachedCountries
        } else {
            do {
                print("Attempting to fetch countries")
                let countries: [CountryDTO] = try await performRequest(CountriesRequest())
                cachedCountries = countries
                return countries
            } catch {
                print("Failed to fetch countries with error: \(error)")
                throw error
            }
        }
    }
}
