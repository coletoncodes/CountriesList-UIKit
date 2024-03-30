//
//  CountryDTO.swift
//  CountriesList-UIKit
//
//  Created by Coleton Gorecke on 3/26/24.
//

import Foundation

struct CountryDTO: Codable, Equatable {
    let name: String
    let region: String
    let code: String
    let capital: String
}

extension CountryDTO {
    var asCountry: Country {
        Country(name: self.name, region: self.region, code: self.code, capital: self.capital)
    }
}
