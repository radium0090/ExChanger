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
            var amount = String()
            for currency in self.currencyName {
                if self.currencyName[self.inputValueTag] == currency {
                    fromValue = currency
                    amount = self.currencyValue[self.inputValueTag]
                } else {
                    toValue = currency
                }
            }
            
            CurrencylayerAPIClien().requestCurrencyConvert(from: fromValue, to: toValue, amount: amount) { success, convert, error in
                if success {
                    if let conertValue = convert {
                        if self.inputValueTag == 0 {
                            self.currencyValue[1] = String(conertValue.result)
                        } else {
                            self.currencyValue[0] = String(conertValue.result)
                        }
                        self.convert = conertValue
                        DispatchQueue.main.async {
                            CoreDataClient.shared.createConvertion(dateTime: Date(timeIntervalSince1970: TimeInterval(conertValue.info.timestamp)),
                                                                    baseKeyName: conertValue.query.from,
                                                                    baseValue: conertValue.query.amount,
                                                                    targetKeyName: conertValue.query.to,
                                                                    targetValue: conertValue.result)
                        }
                        observable.onNext(true)
                    } else {
                        observable.onNext(false)
                    }
                } else {
                    observable.onError(error! as! Error)
                }
            }
            return Disposables.create()
        }
    }
}
