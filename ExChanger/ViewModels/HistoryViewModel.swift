import Foundation
import UIKit
import RxDataSources
import RxSwift
import CoreData

class HistoryViewModel {
    
    let items = PublishSubject<[SectionOfConversion]>()
    
        func updateItem() {
            var sections: [SectionOfConversion] = []
            
            // test dummy data
            sections.append(SectionOfConversion(header: "", items: CoreDataClient.shared.fetchConversion()))
            items.onNext(sections)
        }
    
}

