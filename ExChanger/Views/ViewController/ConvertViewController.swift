//
//  ConvertViewController.swift
//  ExChanger
//
//  Created by Sabbir Ahmed on 25/7/20.
//  Copyright © 2020 Grey Matter. All rights reserved.
//

import Foundation
import UIKit

class ConvertViewController: UIViewController {
    
    override func viewDidLoad() {
        // for test
        saveConversion(dt: Date(), bk: "USD", bv: 12.34, tk: "JPY", tv: 56.78)
        saveConversion(dt: Date(), bk: "AEK", bv: 1.23, tk: "JPY", tv: 4.56)
    }
    
    func saveConversion(dt: Date, bk: String, bv: Float, tk: String, tv: Float) {
        let sharedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let appDel = (UIApplication.shared.delegate as! AppDelegate)
        //インスタンス化をする
        let dict = [
            "dateTime": dt,
            "baseKeyName": bk,
            "baseValue": bv,
            "targetKeyName": tk,
            "targetValue": tv
        ] as [String : Any]
        _ = HistoryModel(dictionary: dict as [String : AnyObject], context: sharedContext)
        appDel.saveContext()
        print("save contents.............")
    }
}
