//
//  Quotes.swift
//  ExChanger
//
//  Created by Sabbir Ahmed on 27/7/20.
//  Copyright © 2020 Grey Matter. All rights reserved.
//

import Foundation

struct Quotes: Identifiable, Decodable {
    let id = UUID()
    let currency: String
    let rate : Double
}
