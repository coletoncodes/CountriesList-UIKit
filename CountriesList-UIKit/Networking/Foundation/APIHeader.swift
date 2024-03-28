//
//  APIHeader.swift
//  CountriesList-UIKit
//
//  Created by Coleton Gorecke on 3/26/24.
//

import Foundation

struct APIHeader: Codable, Hashable {
    let key: String
    let value: String
    
    static var contentType: APIHeader {
        self.init(key: "Content-Type", value: "application/json")
    }
}
