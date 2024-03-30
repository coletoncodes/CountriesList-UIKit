//
//  APIConstantsTests.swift
//  CountriesListUnitTests
//
//  Created by Coleton Gorecke on 3/29/24.
//

@testable import CountriesList_UIKit
import XCTest

final class APIConstantsTests: MockInjectingTestCase {

    func testURLString() {
        let expectedURLString = "https://gist.githubusercontent.com/peymano-wmt/32dcb892b06648910ddd40406e37fdab/raw/db25946fd77c5873b0303b858e861ce724e0dcd0/countries.json"
        
        XCTAssertEqual(APIConstants.urlString, expectedURLString)
    }
}
