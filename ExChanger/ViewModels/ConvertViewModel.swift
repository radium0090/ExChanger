//
//  ConvertViewModel.swift
//  ExChanger
//
//  Created by Sabbir Ahmed on 25/7/20.
//  Copyright © 2020 Grey Matter. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CoreData

class ConvertViewModel {
    
    var currencyTag = 0
    var inputValueTag = 0
    
    var convert: Convert!
    
    var currencyName = ["USD", "JPY"]
    var currencyValue = ["0", "0"]
    
    func fatchCurrencyConvert() -> Observable<Bool> {
        return Observable<Bool>.create { observable in
            var fromValue = String()
            var toValue = String()
            var amount: Double = 0
            for currency in self.currencyName {
                if self.currencyName[self.inputValueTag] == currency {
                    fromValue = currency
                    amount = Double(self.currencyValue[self.inputValueTag]) ?? 0
                } else {
                    toValue = currency
                }
            }
            
            CurrencylayerAPIClien().requestCurrencyConvert(from: fromValue, to: toValue, amount: amount) { success, result, error in
                if success {
                    if let result = result {
                        if self.inputValueTag == 0 {
                            self.currencyValue[1] = String(result)
                        } else {
                            self.currencyValue[0] = String(result)
                        }
                        DispatchQueue.main.async {
                            CoreDataClient.shared.createConvertion(dateTime: Date(),
                                                                    baseKeyName: fromValue,
                                                                    baseValue: amount,
                                                                    targetKeyName: toValue,
                                                                    targetValue: result)
                        }
                        observable.onNext(true)
                    } else {
                        observable.onNext(false)
                    }
                } else {
                    if let error = error {
                        observable.onError(error as! Error)
                    } else {
                        observable.onError(NSError(domain: "", code: -1, userInfo: nil))
                    }
                }
            }
            return Disposables.create()
        }
    }
}
