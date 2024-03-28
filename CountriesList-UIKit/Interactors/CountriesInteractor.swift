//
//  CountriesInteractor.swift
//  CountriesList-UIKit
//
//  Created by Coleton Gorecke on 3/26/24.
//

import Foundation

protocol CountriesInteracting {
    var countries: [Country] { get }
    func fetchCountries() async throws
}

final class CountriesInteractor: CountriesInteracting {
    // MARK: - Dependencies
    private let localStore: CountriesLocalStore
    private let countriesRequester: CountriesRequesting
    
    init(
        localStore: CountriesLocalStore = CountriesLocalRepo(),
        countriesRequester: CountriesRequesting = CountriesRequestor()
    ) {
        self.localStore = localStore
        self.countriesRequester = countriesRequester
    }
    
    // MARK: - Interface
    var countries: [Country] {
        localStore.countries.map(\.asCountry)
    }
    
    func fetchCountries() async throws {
        do {
            let countries = try await countriesRequester.fetchCountries()
            localStore.save(countries: countries)
        } catch {
            print("Failed to fetch countries with error: \(error)")
            throw error
        }
    }
}
