//
//  UserDefaultsStore.swift
//  CountriesList-UIKit
//
//  Created by Coleton Gorecke on 3/26/24.
//

import Factory
import Foundation

class UserDefaultsStore<E: Codable> {
    // MARK: - Dependencies
    @Injected(\.userDefaultsProtocol) private var userDefaults
    private let key: String
    
    // MARK: - Initializer
    init(key: UserDefaultsKeys) {
        self.key = key.rawValue
    }
    
    // MARK: - Private Properties
    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        // add strategies if needed
        return decoder
    }()
    
    private lazy var encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        // add strategies if needed
        return encoder
    }()
    
    // MARK: - Interface
    func set(value: E) throws {
        do {
            let encodedData = try encoder.encode(value)
            userDefaults.setValue(encodedData, forKey: key)
        } catch {
            print("Failed to set value: \(value) with error: \(error)")
            throw UserDefaultsStoreError.encodingError
        }
    }
    
    var value: E? {
        do {
            guard let data = userDefaults.data(forKey: key) else {
                print("No data for key: \(key) found")
                throw UserDefaultsStoreError.noValuePersisted
            }
            return try decoder.decode(E.self, from: data)
        } catch {
            print("Failed to decode object of type: \(String(describing: E.self)) with error: \(error)")
            return nil
        }
    }
}

enum UserDefaultsStoreError: Error {
    case noValuePersisted
    case encodingError
    case decodingError
}
