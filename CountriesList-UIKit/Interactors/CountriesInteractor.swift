//
//  CountriesInteractor.swift
//  CountriesList-UIKit
//
//  Created by Coleton Gorecke on 3/26/24.
//

import Factory
import Foundation

protocol CountriesInteracting {
    var countries: [Country] { get }
    func fetchCountries() async throws
}

final class CountriesInteractor: CountriesInteracting {
    // MARK: - Dependencies
    @Injected(\.countriesLocalStore) private var localStore
    @Injected(\.countriesRequesting) private var countriesRequesting
    
    // MARK: - Interface
    var countries: [Country] {
        localStore.countries.map(\.asCountry)
    }
    
    func fetchCountries() async throws {
        do {
            let countries = try await countriesRequesting.fetchCountries()
            localStore.save(countries: countries)
        } catch {
            print("Failed to fetch countries with error: \(error)")
            throw error
        }
    }
}
