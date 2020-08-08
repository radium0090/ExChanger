//
//  CurrencyListViewModel.swift
//  ExChanger
//
//  Created by Sabbir Ahmed on 25/7/20.
//  Copyright © 2020 Grey Matter. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CurrencyListViewModel {
    
    var currenciesDictionary = [String: [Currencies]]()
    var sectionTitles = [String]()
    
    func fatchCurrencies() -> Observable<Bool> {
        return Observable<Bool>.create { observable in
            CurrencylayerAPIClien().requestCurrences() { success, currencies, error in
                if success {
                    if let currencyList = currencies {
                        
                        for currency in currencyList {
                            // Get the first letter of the avenger name and build the dictionary
                            let firstLetterIndex = currency.currency.index(currency.currency.startIndex, offsetBy: 1)
                            let avengerKey = String(currency.currency[..<firstLetterIndex])
                            
                            if var avengerValues = self.currenciesDictionary[avengerKey] {
                                avengerValues.append(currency)
                                self.currenciesDictionary[avengerKey] = avengerValues
                            } else {
                                self.currenciesDictionary[avengerKey] = [currency]
                            }
                        }
                        
                        self.sectionTitles = self.currenciesDictionary.keys.sorted(by: { $0 < $1 })
                        
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
