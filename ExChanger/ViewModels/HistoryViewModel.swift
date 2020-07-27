import Foundation
import UIKit
import RxDataSources
import RxSwift
import CoreData

class HistoryViewModel {
    let items = PublishSubject<[SectionOfConversion]>()
    
    // set and update data to tableView
    func updateItem() {
        var sections: [SectionOfConversion] = []
        // test dummy data
        sections.append(SectionOfConversion(header: "Conversion History",
                                            items: [SectionOfConversion.Item(dateTime: Date(),
                                                                             baseKeyName:"USD",
                                                                             baseValue: 1.23,
                                                                             targetKeyName:"JPY",
                                                                             targetValue:8.5),
                                                    SectionOfConversion.Item(dateTime: Date(),
                                                                             baseKeyName:"USD",
                                                                             baseValue: 7.98,
                                                                             targetKeyName:"JPY",
                                                                             targetValue:56.87)
        ]))
        
        items.onNext(sections)
    }
    
    // TODO:
    func fetchAllHistory() -> [Conversion] {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            // CoreDataからデータをfetch
//            let fetchRequest: NSFetchRequest<ConversionModel> = ExChanger.fetchRequest()
//            let res = try context.fetch(fetchRequest) as! [Conversion]
//            return res
//            get data frm coredata
//            ...
            return []
        } catch {
            print("Error")
            fatalError()
        }
    }
    
}

