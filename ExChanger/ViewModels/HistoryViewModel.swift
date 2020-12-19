import Foundation
import UIKit
import RxDataSources
import RxSwift
import CoreData

class HistoryViewModel {
    
    let items = PublishSubject<[SectionOfConversion]>()
    
    func updateItem() {
        var sections: [SectionOfConversion] = []
        let conversions = CoreDataClient.shared.fetchConversion().reversed()
        var sectionTitle = String()
        var sectionItem = [Conversion]()
        for item in conversions {
            if sectionTitle == ExchangerUtil.sharedInstance().dateAsString(item.dateTime!, dateFormat: "yyyy-MM-dd") {
                sectionItem.append(item)
            } else {
                if sectionItem.count != 0 {
                    sections.append(SectionOfConversion(header: sectionTitle, items: sectionItem))
                    sectionItem.removeAll()
                }
                sectionTitle = ExchangerUtil.sharedInstance().dateAsString(item.dateTime!, dateFormat: "yyyy-MM-dd")
                sectionItem.append(item)
            }
        }
        
        if sectionItem.count != 0 {
            sections.append(SectionOfConversion(header: sectionTitle, items: sectionItem))
        }
        
        items.onNext(sections)
    }
    
}

