//
//  CurrenciesViewModel.swift
//  ExChanger
//
//  Created by Sabbir Ahmed on 27/7/20.
//  Copyright © 2020 Grey Matter. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CurrenciesViewModel{
    var currencyLive = [Quotes]()
    var source = "USD"
    
    func fatchCurrenciesLive() -> Observable<Bool> {
        return Observable<Bool>.create { observable in
            CurrencylayerAPIClien().requestCurrencyLive(source: self.source, completionHandler: { success, currencies, error in
                if success {
                    if let currencyList = currencies {
                        self.currencyLive = currencyList
                        observable.onNext(true)
                    } else {
                        observable.onNext(false)
                    }
                } else {
                    observable.onError(error! as! Error)
                }
            })
            return Disposables.create()
        }
    }
}
