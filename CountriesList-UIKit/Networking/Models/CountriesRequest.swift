//
//  CountriesRequest.swift
//  CountriesList-UIKit
//
//  Created by Coleton Gorecke on 3/26/24.
//

import Foundation

struct CountriesRequest: APIRequest {
    typealias Response = [CountryDTO]
    var method: HTTPMethod { .GET }
}
