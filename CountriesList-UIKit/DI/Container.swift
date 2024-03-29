//
//  Container.swift
//  CountriesList-UIKit
//
//  Created by Coleton Gorecke on 3/29/24.
//

import Factory
import Foundation

extension Container {
    var countriesLocalStore: Factory<CountriesLocalStore> {
        self { CountriesLocalRepo() as CountriesLocalStore }
            .cached
    }
    
    var countriesRequesting: Factory<CountriesRequesting> {
        self { CountriesRequestor() as CountriesRequesting }
            .cached
    }
    
    var countriesInteracting: Factory<CountriesInteracting> {
        self { CountriesInteractor() as CountriesInteracting }
            .cached
    }
    
    var countriesListViewModel: Factory<CountriesListViewModel> {
        self { CountriesListViewModel() }
            .cached
    }
    
    var userDefaultsProtocol: Factory<UserDefaultsProtocol> {
        self { UserDefaults.standard as UserDefaultsProtocol }
            .cached
    }
    
    var countriesUserDefaultsStore: Factory<UserDefaultsStore<[CountryDTO]>> {
        self { UserDefaultsStore(key: .countries) }
            .cached
    }
}
