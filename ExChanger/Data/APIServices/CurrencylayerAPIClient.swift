//
//  CurrencylayerAPIClient.swift
//  ExChanger
//
//  Created by Sabbir Ahmed on 26/7/20.
//  Copyright © 2020 Grey Matter. All rights reserved.
//

import Foundation

class CurrencylayerAPIClien {
    
    let session = URLSession.shared
    
    func requestCurrences(_ completionHandler: @escaping (_ success: Bool, _ quotes: [Currencies]?, _ error: String?) -> Void) {
        if Reachability.isConnectedToNetwork() {
            
            let fullUrl = "https://cdn.jsdelivr.net/gh/fawazahmed0/currency-api@1/latest/currencies.json"
            guard let url = URL(string: fullUrl) else { return }
            let request = URLRequest(url: url)
            let task = session.dataTask(with: request, completionHandler: { data, response, error in
                if let error = error {
                    completionHandler(false, nil, error.localizedDescription)
                } else if let data = data {
                    do {
                        let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
                        var currencyList = [Currencies]()
                        for key in result.keys.sorted() {
                            currencyList.append(Currencies(currency: key, countryName: result[key] as! String))
                        }
                        completionHandler(true, currencyList, nil)
                    } catch {
                        completionHandler(false, nil, "Unable to process retrieved data.")
                    }
                }
            })
            task.resume()
        }
        else {
            completionHandler(false, nil, "Please check you internet connection and try again.")
        }
    }
    
    func requestCurrencyLive(source: String, completionHandler: @escaping (_ success: Bool, _ quotes: [Quotes]?, _ error: String?) -> Void) {
        if Reachability.isConnectedToNetwork() {
            
            let fullUrl = "https://cdn.jsdelivr.net/gh/fawazahmed0/currency-api@1/latest/currencies/\(source.lowercased()).json"
            guard let url = URL(string: fullUrl) else { return }
            let request = URLRequest(url: url)
            let task = session.dataTask(with: request, completionHandler: { data, response, error in
                if let error = error {
                    completionHandler(false, nil, error.localizedDescription)
                } else if let data = data {
                    do {
                        let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
                        var currencyList = [Quotes]()
                        if let usdRates = result[source.lowercased()] as? [String: Double] {
                            for (currency, rate) in usdRates {
                                currencyList.append(Quotes(currency: currency, rate: rate))
                            }
                        }
                        completionHandler(true, currencyList, nil)
                    } catch {
                        completionHandler(false, nil, "Unable to process retrieved data.")
                    }
                }
            })
            task.resume()
        }
        else {
            completionHandler(false, nil, "Please check you internet connection and try again.")
        }
    }
    
    func requestCurrencyConvert(from: String, to: String, amount: Double, completionHandler: @escaping (_ success: Bool, _ result: Double?, _ error: String?) -> Void) {
        if Reachability.isConnectedToNetwork() {
            
            let fullUrl = "https://cdn.jsdelivr.net/gh/fawazahmed0/currency-api@1/latest/currencies/\(from.lowercased())/\(to.lowercased()).json"
            guard let url = URL(string: fullUrl) else { return }
            let request = URLRequest(url: url)
            let task = session.dataTask(with: request, completionHandler: { data, response, error in
                if let error = error {
                    completionHandler(false, nil, error.localizedDescription)
                } else if let data = data {
                    do {
                        let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
                        if let rate = result[to.lowercased()] as? Double {
                            let convertedAmount = amount * rate
                            completionHandler(true, convertedAmount, nil)
                        } else {
                            completionHandler(false, nil, "Unable to convert currency.")
                        }
                    } catch {
                        completionHandler(false, nil, "Unable to process retrieved data.")
                    }
                }
            })
            task.resume()
        } else {
            completionHandler(false, nil, "Please check your internet connection and try again.")
        }
    }
}
