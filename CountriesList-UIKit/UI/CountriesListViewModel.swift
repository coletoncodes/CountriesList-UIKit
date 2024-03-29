//
//  CountriesListViewModel.swift
//  CountriesList-UIKit
//
//  Created by Coleton Gorecke on 3/26/24.
//

import Foundation

@MainActor
final class CountriesListViewModel: ObservableObject {
    // MARK: - Dependencies
    private let countriesInteracting: CountriesInteracting
    
    init(countriesInteracting: CountriesInteracting = CountriesInteractor()) {
        self.countriesInteracting = countriesInteracting
    }
    
    // MARK: - Published Properties
    @Published var filteredCountries: [Country] = []
    @Published var isFetchingCountries: Bool = false
    @Published var errorMessage: String?
    
    private var allCountries: [Country] = []
    
    // MARK: - Interface
    func fetchCountries() {
        Task {
            do {
                try await countriesInteracting.fetchCountries()
                self.allCountries = countriesInteracting.countries
                self.filteredCountries = allCountries
            } catch {
                print("Failed to fetch countries with error: \(error)")
                self.errorMessage = String(describing: error)
            }
            return
        }
    }
    
    /// Filter countries based on searchText
    func filterCountries(for searchText: String) {
        filteredCountries = allCountries.filter { country in
            country.name.contains(searchText) || country.capital.contains(searchText) ||
            country.region.contains(searchText) || country.code.contains(searchText)
        }
    }
    
    func resetFilteredCountries() {
        filteredCountries = allCountries
    }
}
