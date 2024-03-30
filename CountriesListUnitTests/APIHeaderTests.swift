//
//  APIHeaderTests.swift
//  CountriesListUnitTests
//
//  Created by Coleton Gorecke on 3/29/24.
//

@testable import CountriesList_UIKit
import XCTest

final class APIHeaderTests: MockInjectingTestCase {

    func testContentTypeHeader() {
        let expectedKey = "Content-Type"
        let expectedValue = "application/json"
        let header: APIHeader = .contentType
        XCTAssertEqual(header.key, expectedKey)
        XCTAssertEqual(header.value, expectedValue)
    }

}
