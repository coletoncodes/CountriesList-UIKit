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
    
    private(set) var allCountries: [Country] = []
    
    nonisolated init() {}
    
    // MARK: - Interface
    func fetchCountries() {
        Task {
            self.isFetchingCountries = true
            do {
                self.allCountries = try await countriesInteracting.fetchCountries()
                resetFilteredCountries()
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
            country.name.containsLowerCaseText(searchText) ||
            country.capital.containsLowerCaseText(searchText) ||
            country.region.containsLowerCaseText(searchText) ||
            country.code.containsLowerCaseText(searchText)
        }
    }
    
    func resetFilteredCountries() {
        filteredCountries = allCountries
    }
}

fileprivate extension String {
    func containsLowerCaseText(_ stringValue: String) -> Bool {
        let lowerCasedText = stringValue.lowercased()
        return self.lowercased().contains(lowerCasedText)
    }
}
