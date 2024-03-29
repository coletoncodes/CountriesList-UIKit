//
//  CountriesLocalStore.swift
//  CountriesList-UIKit
//
//  Created by Coleton Gorecke on 3/26/24.
//

import Factory
import Foundation

protocol CountriesLocalStore {
    var countries: [CountryDTO] { get }
    func save(countries: [CountryDTO])
}

final class CountriesLocalRepo: CountriesLocalStore {
    // MARK: - Dependencies
    @Injected(\.countriesUserDefaultsStore) private var countriesUDStore
    
    // MARK: - Interface
    var countries: [CountryDTO] {
        if let persistedCountries = countriesUDStore.value {
            return persistedCountries
        }
        return []
    }
    
    func save(countries: [CountryDTO]) {
        do {
            try countriesUDStore.set(value: countries)
        } catch {
            print("Failed to save countries with error: \(error)")
        }
    }
}
