//
//  CountriesRequestTests.swift
//  CountriesListUnitTests
//
//  Created by Coleton Gorecke on 3/29/24.
//

@testable import CountriesList_UIKit
import XCTest

final class CountriesRequestTests: MockInjectingTestCase {

    func testCountriesRequest() {
        let request = CountriesRequest()
        
        XCTAssertEqual(request.method, .GET)
    }
}
