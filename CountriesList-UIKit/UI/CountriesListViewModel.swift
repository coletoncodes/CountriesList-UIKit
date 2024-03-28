//
//  CountriesListViewModel.swift
//  CountriesList-UIKit
//
//  Created by Coleton Gorecke on 3/26/24.
//

import Foundation

final class CountriesListViewModel: ObservableObject {
    // MARK: - Dependencies
    private let countriesInteracting: CountriesInteracting
    
    init(countriesInteracting: CountriesInteracting = CountriesInteractor()) {
        self.countriesInteracting = countriesInteracting
    }
    
    // MARK: - Published Properties
    @Published var countries: [Country] = []
    @Published var isFetchingCountries: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Interface
    func fetchCountries() {
        Task {
            do {
                try await countriesInteracting.fetchCountries()
                self.countries = countriesInteracting.countries
            } catch {
                print("Failed to fetch countries with error: \(error)")
                self.errorMessage = String(describing: error)
            }
        }
    }
}
