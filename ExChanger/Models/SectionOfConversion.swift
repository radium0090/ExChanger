//
//  SectionOfConversion.swift
//  ExChanger
//
//  Created by Sabbir Ahmed on 29/7/20.
//  Copyright © 2020 Grey Matter. All rights reserved.
//

import Foundation
import RxDataSources
import CoreData

struct SectionOfConversion {
    var header: String
    var items: [Item]
}

extension SectionOfConversion: SectionModelType {
    typealias Item = Conversion
    
    init(original: SectionOfConversion, items: [SectionOfConversion.Item]) {
        self = original
        self.items = items
    }
}
