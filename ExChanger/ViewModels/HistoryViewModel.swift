//
//  HistoryViewModel.swift
//  ExChanger
//
//  Created by Sabbir Ahmed on 25/7/20.
//  Copyright © 2020 Grey Matter. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class HistoryViewModel: NSObject, UITableViewDelegate, UITableViewDataSource {
    var fetchedConversions: [HistoryModel]!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if fetchedConversions == nil {
            return 0
        }
        return fetchedConversions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historycell") as! HistoryTableViewCell
        cell.setCell(dt: fetchedConversions[indexPath.row].dateTime,
                     bk: fetchedConversions[indexPath.row].baseKeyName,
                     bv: fetchedConversions[indexPath.row].baseValue,
                     tk: fetchedConversions[indexPath.row].targetKeyName,
                     tv: fetchedConversions[indexPath.row].targetValue)
        return cell
    }
    
    func fetchAllConversions() -> [HistoryModel] {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            // CoreDataからデータをfetch
            let fetchRequest: NSFetchRequest<ExChanger> = ExChanger.fetchRequest()
            let res = try context.fetch(fetchRequest) as! [HistoryModel]
            return res
        } catch {
            print("Error")
            fatalError()
        }
    }
    
}

