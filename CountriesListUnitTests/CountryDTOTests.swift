//
//  CountryDTOTests.swift
//  CountriesListUnitTests
//
//  Created by Coleton Gorecke on 3/29/24.
//

@testable import CountriesList_UIKit
import XCTest

final class CountryDTOTests: MockInjectingTestCase {

    func testAsCountry() {
        /** Given */
        let mockName = "Some name"
        let mockRegion = "some region"
        let mockCode = "some code"
        let mockCapital = "some capital"
        let mockCountryDTO: CountryDTO = .init(name: mockName, region: mockRegion, code: mockCode, capital: mockCapital)
        
        /** When */
        let asCountry = mockCountryDTO.asCountry
        
        /** Then */
        XCTAssertEqual(asCountry.name, mockName)
        XCTAssertEqual(asCountry.region, mockRegion)
        XCTAssertEqual(asCountry.code, mockCode)
        XCTAssertEqual(asCountry.capital, mockCapital)
    }
}
