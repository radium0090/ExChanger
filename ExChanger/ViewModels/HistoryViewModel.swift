import Foundation
import UIKit
import RxDataSources
import RxSwift
import CoreData

class HistoryViewModel {
    
    let items = PublishSubject<[SectionOfConversion]>()
    
    func updateItem() {
        var sections: [SectionOfConversion] = []
        sections.append(SectionOfConversion(header: ExchangerUtil.sharedInstance().dateAsString(Date(), dateFormat: "yyyy-MM-dd"),
                                            items: CoreDataClient.shared.fetchConversion()))
        items.onNext(sections)
    }
    
}

