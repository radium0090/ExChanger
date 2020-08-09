//
//  CoreDataManager.swift
//  ExChanger
//
//  Created by Sabbir Ahmed on 29/7/20.
//  Copyright © 2020 Grey Matter. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public class CoreDataClient {
    
    public static let shared = CoreDataClient()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    public func createConvertion(dateTime: Date, baseKeyName: String, baseValue: Double, targetKeyName: String, targetValue: Double){
        let context = appDelegate.persistentContainer.viewContext
        let conversion = NSEntityDescription.insertNewObject(forEntityName: "Conversion", into: context) as! Conversion
        conversion.dateTime = dateTime
        conversion.baseKeyName = baseKeyName
        conversion.baseValue = baseValue
        conversion.targetKeyName = targetKeyName
        conversion.targetValue = targetValue
        
        do {
            try context.save()
            print("✅ Conversion saved succesfuly")
        } catch let error {
            print("❌ Failed to create Conversion: \(error.localizedDescription)")
        }
    }
    
    public func fetchConversion() -> [Conversion]{
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Conversion>(entityName: "Conversion")
        
        do{
            let conversion = try context.fetch(fetchRequest)
            return conversion
        }catch let fetchErr {
            print("❌ Failed to fetch Conversion:",fetchErr)
            return [Conversion]()
        }
    }
    
    public func removeConversion(at offsets: Int) {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Conversion>(entityName: "Conversion")
        
        do{
            let conversion = try context.fetch(fetchRequest)
            context.delete(conversion[offsets])
            try context.save()
        }catch let fetchErr {
            print("❌ Failed to fetch and delete Conversion:", fetchErr)
        }
    }
}
