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
    
    // Base Url
    let baseUrl = "https://api.currencylayer.com"
    
    // Access Key
    var accessKey = "fd6e151011f93dc8fbee0ab2f8c2167b"
    
    func requestCurrences(_ completionHandler: @escaping (_ success: Bool, _ quotes: [Currencies]?, _ error: String?) -> Void) {
        if Reachability.isConnectedToNetwork() {
            let fullUrl = "\(baseUrl)/\(Paths.list)"
            
            guard var components = URLComponents(string: fullUrl) else { return }
            
            components.queryItems = [
                URLQueryItem(name: "access_key", value: accessKey),
                URLQueryItem(name: "format", value: "1")
            ]
            
            print(components.url as Any)
            
            let request = URLRequest(url: components.url!)
            
            let task = session.dataTask(with: request, completionHandler: { data, response, error in
                if error != nil {
                    completionHandler(false, nil, error!.localizedDescription)
                }
                else {
                    do {
                        let result = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                        if let dictionary = result["currencies"] as! [String : AnyObject]? {
                            var currencyList = [Currencies]()
                            for key in dictionary.keys.sorted() {
                                currencyList.append(Currencies(currency: key, countryName: dictionary[key] as! String))
                            }
                            completionHandler(true, currencyList, nil)
                        }
                        else {
                            completionHandler(false, nil, nil)
                        }
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
            let fullUrl = "\(baseUrl)/\(Paths.live)"
            
            guard var components = URLComponents(string: fullUrl) else { return }
            
            components.queryItems = [
                URLQueryItem(name: "access_key", value: accessKey),
                URLQueryItem(name: "source", value: source),
                URLQueryItem(name: "format", value: "1")
            ]
            
            print(components.url as Any)
            
            let request = URLRequest(url: components.url!)
            
            let task = session.dataTask(with: request, completionHandler: { data, response, error in
                if error != nil {
                    completionHandler(false, nil, error!.localizedDescription)
                }
                else {
                    do {
                        let result = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                        if let dictionary = result["quotes"] as! [String : AnyObject]? {
                            var currencyList = [Quotes]()
                            for key in dictionary.keys {
                                currencyList.append(Quotes(currency: key, rate: dictionary[key] as! Double))
                            }
                            completionHandler(true, currencyList, nil)
                        }
                        else {
                            completionHandler(false, nil, nil)
                        }
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
    
    func requestCurrencyConvert(from: String, to: String, amount: String, completionHandler: @escaping (_ success: Bool, _ quotes: Convert?, _ error: String?) -> Void) {
        if Reachability.isConnectedToNetwork() {
            let fullUrl = "\(baseUrl)/\(Paths.convert)"
            
            guard var components = URLComponents(string: fullUrl) else { return }
            
            components.queryItems = [
                URLQueryItem(name: "access_key", value: accessKey),
                URLQueryItem(name: "from", value: from),
                URLQueryItem(name: "to", value: to),
                URLQueryItem(name: "amount", value: amount),
                URLQueryItem(name: "format", value: "1")
            ]
            
            print(components.url as Any)
            
            let request = URLRequest(url: components.url!)
            
            let task = session.dataTask(with: request, completionHandler: { data, response, error in
                if error != nil {
                    completionHandler(false, nil, error!.localizedDescription)
                }
                else {
                    do {
                        if let data = data {
                            let convertResult = try JSONDecoder().decode(Convert.self, from: data)
                            completionHandler(true, convertResult, nil)
                        } else {
                            completionHandler(false, nil, nil)
                        }
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
}
