//
//  CountriesInteractor.swift
//  CountriesList-UIKit
//
//  Created by Coleton Gorecke on 3/26/24.
//

import Factory
import Foundation

protocol CountriesInteracting {
    func fetchCountries() async throws -> [Country]
}

final class CountriesInteractor: CountriesInteracting {
    // MARK: - Dependencies
    @Injected(\.countriesLocalStore) private var localStore
    @Injected(\.countriesRequesting) private var countriesRequesting
    
    // MARK: - Interface
    func fetchCountries() async throws -> [Country] {
        do {
            let countries = try await countriesRequesting.fetchCountries()
            localStore.save(countries: countries)
            return localStore.countries.map(\.asCountry)
        } catch {
            print("Failed to fetch countries with error: \(error)")
            throw error
        }
    }
}
