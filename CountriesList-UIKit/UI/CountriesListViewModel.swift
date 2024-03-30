//
//  CountriesListViewModel.swift
//  CountriesList-UIKit
//
//  Created by Coleton Gorecke on 3/26/24.
//

import Factory
import Foundation

@MainActor
final class CountriesListViewModel: ObservableObject {
    // MARK: - Dependencies
    @Injected(\.countriesInteracting) private var countriesInteracting
    
    // MARK: - Published Properties
    @Published var filteredCountries: [Country] = []
    @Published var isFetchingCountries: Bool = false
    @Published var errorMessage: String?
    
    private var allCountries: [Country] = []
    
    nonisolated init() {}
    
    // MARK: - Interface
    func fetchCountries() {
        Task {
            self.isFetchingCountries = true
            do {
                try await countriesInteracting.fetchCountries()
                self.allCountries = countriesInteracting.countries
                self.filteredCountries = allCountries
            } catch {
                print("Failed to fetch countries with error: \(error)")
                self.errorMessage = String(describing: error)
            }
            self.isFetchingCountries = false
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
