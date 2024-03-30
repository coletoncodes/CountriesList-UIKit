//
//  CountriesLocalRepoTests.swift
//  CountriesListUnitTests
//
//  Created by Coleton Gorecke on 3/29/24.
//

@testable import CountriesList_UIKit
import Factory
import XCTest

final class CountriesLocalRepoTests: MockInjectingTestCase {
    private var sut: CountriesLocalRepo!
    private var mockCountriesUDStore: MockCountriesUserDefaultsStore!

    override func setUp() {
        super.setUp()
        
        mockCountriesUDStore = Container.shared.countriesUserDefaultsStore() as? MockCountriesUserDefaultsStore
        
        sut = CountriesLocalRepo()
    }

    // MARK: - Tests
    func testSaveSuccess() {
        /** Given */
        let mockCountry = CountryDTO(name: "some name", region: "some region", code: "some code", capital: "some capital")
        let mockCountries: [CountryDTO] = Array(repeating: mockCountry, count: 25)
        
        mockCountriesUDStore.setStub = { codableValue in
            /** Then */
            XCTAssertEqual(codableValue as? [CountryDTO], mockCountries)
        }
        
        /** When */
        sut.save(countries: mockCountries)
    }
    
    func testCountriesNotEmpty() {
        /** Given */
        let mockCountry = CountryDTO(name: "some name", region: "some region", code: "some code", capital: "some capital")
        let mockCountries: [CountryDTO] = Array(repeating: mockCountry, count: 25)
        
        mockCountriesUDStore.getValueStub = { _ in
            return mockCountries
        }
        
        /** When */
        let countries = sut.countries
        
        /** Then */
        XCTAssertEqual(countries, mockCountries)
    }
    
    func testCountriesNil() {
        /** Given */
        mockCountriesUDStore.getValueStub = { _ in
            return nil
        }
        
        /** When */
        let countries = sut.countries
        
        /** Then */
        XCTAssertTrue(countries.isEmpty)
    }
}
