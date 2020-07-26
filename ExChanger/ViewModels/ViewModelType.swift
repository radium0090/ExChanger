//
//  ViewModelType.swift
//  ExChanger
//
//  Created by 皮皮 on 2020/07/26.
//  Copyright © 2020 Grey Matter. All rights reserved.
//

import UIKit
import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    associatedtype State
    
    func transform(input: Input) -> Output
}
