import Foundation
import RxDataSources
import CoreData

// build struct for conversion history model
struct Conversion {
    let dateTime: Date
    let baseKeyName: String
    let baseValue: Float
    let targetKeyName:String
    let targetValue: Float
}

// set sections for list of history
struct SectionOfConversion {
    var header: String
    var items: [Item]
}

extension SectionOfConversion: SectionModelType {
    typealias Item = Conversion
    
    init(original: SectionOfConversion, items: [SectionOfConversion.Item]) {
        self = original
        self.items = items
    }
}

// conversion model def with coredata init
class ConversionModel: NSManagedObject {
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
