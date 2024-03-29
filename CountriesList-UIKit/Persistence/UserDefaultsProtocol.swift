//
//  UserDefaultsProtocol.swift
//  CountriesList-UIKit
//
//  Created by Coleton Gorecke on 3/29/24.
//

import Foundation

enum UserDefaultsKeys: String {
    case countries
}

protocol UserDefaultsProtocol {
    func setValue(_ value: Any?, forKey key: String)
    func data(forKey defaultName: String) -> Data?
}

extension UserDefaults: UserDefaultsProtocol {}
