//
//  CountriesLocalStore.swift
//  CountriesList-UIKit
//
//  Created by Coleton Gorecke on 3/26/24.
//

import Foundation

protocol CountriesLocalStore {
    var countries: [CountryDTO] { get }
    func save(countries: [CountryDTO])
}

final class CountriesLocalRepo: CountriesLocalStore {
    private let countriesRequesting: CountriesRequesting
    private let userDefaultsStore: UserDefaultsStore<[CountryDTO]>
    
    init(
        countriesRequesting: CountriesRequesting = CountriesRequestor(),
        userDefaultsStore: UserDefaultsStore<[CountryDTO]> = UserDefaultsStore<[CountryDTO]>.init(key: "Countries")
    ) {
        self.countriesRequesting = countriesRequesting
        self.userDefaultsStore = userDefaultsStore
    }
    
    // MARK: - Interface
    var countries: [CountryDTO] {
        if let persistedCountries = userDefaultsStore.value {
            return persistedCountries
        }
        return []
    }
    
    func save(countries: [CountryDTO]) {
        do {
            try userDefaultsStore.set(value: countries)
        } catch {
            print("Failed to save countries with error: \(error)")
        }
    }
}
