//
//  Country.swift
//  CountriesList-UIKit
//
//  Created by Coleton Gorecke on 3/26/24.
//

import Foundation

struct Country: Identifiable, Equatable {
    let id: UUID = UUID()
    let name: String
    let region: String
    let code: String
    let capital: String
}
