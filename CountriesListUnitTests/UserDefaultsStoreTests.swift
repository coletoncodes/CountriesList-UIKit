//
//  UserDefaultsStoreTests.swift
//  CountriesListUnitTests
//
//  Created by Coleton Gorecke on 3/29/24.
//

@testable import CountriesList_UIKit
import Factory
import XCTest

fileprivate struct MockCodableObject: Codable, Equatable {
    let stringValue: String
}

final class UserDefaultsStoreTests: MockInjectingTestCase {
    private var sut: UserDefaultsStore!
    private var mockUserDefaultsProtocol: MockUserDefaultsProtocol!
    
    override func setUp() {
        super.setUp()
        
        mockUserDefaultsProtocol = Container.shared.userDefaultsProtocol() as? MockUserDefaultsProtocol
        
        sut = UserDefaultsStore(key: .mock)
    }
    
    func testSetValueSuccess() throws {
        /** Given */
        let mockObject = MockCodableObject(stringValue: "Some String Value")
        
        mockUserDefaultsProtocol.setValueStub = { value, key in
            XCTAssertNotNil(value as? Data, "No data was saved.")
            XCTAssertEqual(key, UserDefaultsKeys.mock.rawValue, "Incorrect UserDefaults key used for saving.")
        }
        
        /** When */
        do {
            try sut.set(value: mockObject)
            /** Then */
            // success if no failure
        } catch {
            XCTFail("Un unexpected error occurred. Error: \(error)")
        }
    }
    
    func testGetValueNoDataPersisted_ReturnsNil() throws {
        /** Given */
        mockUserDefaultsProtocol.dataForKeyStub = { _ in return nil }
        
        /** When */
        let value = sut.getValue(forType: MockCodableObject.self)
        
        /** Then */
        XCTAssertNil(value)
    }
    
    func testGetValueSuccess() {
        /** Given */
        let mockData = MockCodableObject(stringValue: "some value")
        
        mockUserDefaultsProtocol.dataForKeyStub = { key in
            XCTAssertEqual(key, UserDefaultsKeys.mock.rawValue)
            return try? JSONEncoder().encode(mockData)
        }
        
        /** When */
        let value = sut.getValue(forType: MockCodableObject.self)
        
        /** Then */
        XCTAssertEqual(value, mockData)
    }
}
