//
//  CountriesListViewModelTests.swift
//  CountriesListUnitTests
//
//  Created by Coleton Gorecke on 3/30/24.
//

@testable import CountriesList_UIKit
import Factory
import XCTest

final class CountriesListViewModelTests: MockInjectingTestCase {
    private var sut: CountriesListViewModel!
    private var mockCountriesInteracting: MockCountriesInteracting!

    override func setUp() {
        super.setUp()
        
        self.mockCountriesInteracting = Container.shared.countriesInteracting() as? MockCountriesInteracting
        self.sut = CountriesListViewModel()
    }
    
    // MARK: - Tests
    func testFetchCountriesSuccess_UpdatesFilteredCountries() async {
        // Given
        let expectation = expectation(description: "Awaiting fetch countries to complete")
        let expectedCountries = [
            Country(name: "Country1", region: "Capital1", code: "Region1", capital: "Code1"),
            Country(name: "Country2", region: "Capital2", code: "Region2", capital: "Code2")
        ]
        mockCountriesInteracting.fetchCountriesStub = {
            expectation.fulfill()
            return expectedCountries 
        }

        // When
        sut.fetchCountries()

        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(sut.filteredCountries, expectedCountries, "Filtered countries should be updated with fetched countries.")
    }
    
    func testFetchCountriesFailure_UpdatesErrorMessage() async {
        // Given
        let expectation = expectation(description: "Awaiting fetch countries to fail")
        mockCountriesInteracting.fetchCountriesStub = {
            expectation.fulfill()
            throw MockError.expected
        }

        // When
        sut.fetchCountries()

        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertNotNil(sut.errorMessage, "An error message should be set when fetch fails.")
    }
    
    func testFilterCountries_WithSearchText_FiltersCountries() async {
        // Given
        let expectation = expectation(description: "Awaiting fetch countries to complete")
        let expectedCountries = [
            Country(name: "Country1", region: "Capital1", code: "Region1", capital: "Code1"),
            Country(name: "Country2", region: "Capital2", code: "Region2", capital: "Code2")
        ]
        
        mockCountriesInteracting.fetchCountriesStub = {
            expectation.fulfill()
            return expectedCountries
        }
        
        let searchText = "1"

        // When
        // Countries have been fetched already
        sut.fetchCountries()
        
        // wait for countries fetch to complete
        await fulfillment(of: [expectation], timeout: 1.0)
        
        sut.filterCountries(for: searchText)

        // Then
        XCTAssertEqual(sut.filteredCountries[0], expectedCountries[0], "Should filter countries to those that match the search text.")
    }
    
    func testResetFilteredCountries_ResetsToAllCountries() async {
        // Given
        let expectation = expectation(description: "Awaiting fetch countries to complete")
        let allCountries = [
            Country(name: "Country1", region: "Capital1", code: "Region1", capital: "C1"),
            Country(name: "Country2", region: "Capital2", code: "Region2", capital: "C2")
        ]
        
        mockCountriesInteracting.fetchCountriesStub = {
            expectation.fulfill()
            return allCountries
        }

        // When
        // Countries have been fetched already
        sut.fetchCountries()
        sut.resetFilteredCountries()

        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(sut.filteredCountries, allCountries, "Filtered countries should be reset to include all countries.")
    }
}
