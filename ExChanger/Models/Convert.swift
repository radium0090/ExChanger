//
//  Convert.swift
//  ExChanger
//
//  Created by Sabbir Ahmed on 28/7/20.
//  Copyright © 2020 Grey Matter. All rights reserved.
//

import Foundation

struct Convert: Decodable {
    let success: Bool
    let terms: String
    let privacy: String
    let query: Query
    let info: Info
    let result: Double
}

struct Query: Decodable {
    let from: String
    let to: String
    let amount: Double
}

struct Info: Decodable {
    let timestamp: Int64
    let quote: Double
}
