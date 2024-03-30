//
//  UserDefaultsStore.swift
//  CountriesList-UIKit
//
//  Created by Coleton Gorecke on 3/26/24.
//

import Factory
import Foundation

protocol UserDefaultsStoreProtocol {
    func set<Value: Codable>(value: Value) throws
    func getValue<Object: Codable>(forType type: Object.Type) -> Object?
}

class UserDefaultsStore: UserDefaultsStoreProtocol {
    // MARK: - Dependencies
    @Injected(\.userDefaultsProtocol) private var userDefaults
    
    private let key: String
    
    // MARK: - Initializer
    init(key: UserDefaultsKeys) {
        self.key = key.rawValue
    }
    
    open lazy var encoder: JSONEncoder = {
        return JSONEncoder()
    }()
    
    open lazy var decoder: JSONDecoder = {
        return JSONDecoder()
    }()
    
    // MARK: - Interface
    func set<Value: Codable>(value: Value) throws {
        do {
            let encodedData = try encoder.encode(value)
            userDefaults.setValue(encodedData, forKey: key)
        } catch {
            print("Failed to set value: \(value) with error: \(error)")
            throw UserDefaultsStoreError.encodingError
        }
    }
    
    func getValue<Object: Codable>(forType type: Object.Type) -> Object? {
        do {
            guard let data = userDefaults.data(forKey: key) else {
                print("No data for key: \(key) found")
                throw UserDefaultsStoreError.noValuePersisted
            }
            return try decoder.decode(Object.self, from: data)
        } catch {
            print("Failed to decode object of type: \(String(describing: Object.self)) with error: \(error)")
            return nil
        }
    }
}

enum UserDefaultsStoreError: Error {
    case noValuePersisted
    case encodingError
}
