//
//  Mocks.swift
//  CountriesListUnitTests
//
//  Created by Coleton Gorecke on 3/29/24.
//

@testable import CountriesList_UIKit
import Foundation

enum MockError: Error {
    case expected
}

final class MockCountriesLocalStore: CountriesLocalStore {
    var countriesGetterStub: (() -> [CountryDTO])!
    
    var countries: [CountryDTO] {
        countriesGetterStub()
    }
    
    var saveStub: (([CountryDTO]) -> Void)!
    
    func save(countries: [CountryDTO]) {
        saveStub(countries)
    }
}

final class MockCountriesRequesting: CountriesRequesting {
    var fetchCountriesStub: (() async throws -> [CountryDTO])!
    
    func fetchCountries() async throws -> [CountryDTO] {
        try await fetchCountriesStub()
    }
}

final class MockCountriesInteracting: CountriesInteracting {
    var countriesGetterStub: (() -> [Country])!
    
    var countries: [Country] {
        countriesGetterStub()
    }
    
    var fetchCountriesStub: (() async throws -> Void)!
    
    func fetchCountries() async throws {
        try await fetchCountriesStub()
    }
}

final class MockUserDefaultsProtocol: UserDefaultsProtocol {
    var setValueStub: ((Any?, String) -> Void)!
    
    func setValue(_ value: Any?, forKey key: String) {
        setValueStub(value, key)
    }
    
    var dataForKeyStub: ((String) -> Data?)!
    
    func data(forKey defaultName: String) -> Data? {
        dataForKeyStub(defaultName)
    }
}

final class MockCountriesUserDefaultsStore: UserDefaultsStoreProtocol {
    var setStub: ((Codable) throws -> Void)!
    
    func set<Value: Codable>(value: Value) throws {
        try setStub(value)
    }
    
    var getValueStub: ((Any) -> Any?)!
    
    func getValue<Object: Codable>(forType type: Object.Type) -> Object? {
        getValueStub(type) as? Object
    }
}
