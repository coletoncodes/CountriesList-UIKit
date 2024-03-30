//
//  MockInjectingTestCase.swift
//  CountriesListUnitTests
//
//  Created by Coleton Gorecke on 3/29/24.
//

@testable import CountriesList_UIKit
import Factory
import XCTest

@MainActor
class MockInjectingTestCase: XCTestCase {

    override func setUp() {
        Container.shared.manager.push()
        setupMockDependencies()
    }
    
    override func tearDown() {
        Container.shared.manager.pop()
    }

    private func setupMockDependencies() {
        Container.shared.countriesLocalStore.register {
            MockCountriesLocalStore() as CountriesLocalStore
        }
        
        Container.shared.countriesRequesting.register {
            MockCountriesRequesting() as CountriesRequesting
        }
        
        Container.shared.countriesInteracting.register {
            MockCountriesInteracting() as CountriesInteracting
        }
        
        Container.shared.userDefaultsProtocol.register {
            MockUserDefaultsProtocol() as UserDefaultsProtocol
        }
        
        Container.shared.countriesUserDefaultsStore.register {
            MockCountriesUserDefaultsStore() as UserDefaultsStoreProtocol
        }
    }

}
