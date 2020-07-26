//
//  HistoryModel.swift
//  ExChanger
//
//  Created by 皮皮 on 2020/07/26.
//  Copyright © 2020 Grey Matter. All rights reserved.
//

import Foundation
import CoreData


class HistoryModel: NSManagedObject {
    @NSManaged var dateTime: Date
    @NSManaged var baseKeyName: String
    @NSManaged var baseValue: Float
    @NSManaged var targetKeyName: String
    @NSManaged var targetValue: Float
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(dictionary: [String:AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "ExChanger", in: context)!
        super.init(entity: entity, insertInto: context)
        
        dateTime = dictionary["dateTime"] as! Date
        baseKeyName = dictionary["baseKeyName"] as! String
        baseValue = dictionary["baseValue"] as! Float
        targetKeyName = dictionary["targetKeyName"] as! String
        targetValue = dictionary["targetValue"] as! Float
    }

}
