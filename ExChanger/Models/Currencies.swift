//
//  Currencies.swift
//  ExChanger
//
//  Created by Sabbir Ahmed on 26/7/20.
//  Copyright © 2020 Grey Matter. All rights reserved.
//

import Foundation

struct Currencies: Identifiable, Decodable {
    let id = UUID()
    let currency: String
    let countryName: String
}
