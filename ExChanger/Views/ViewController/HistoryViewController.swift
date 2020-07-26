//
//  HistoryViewController.swift
//  ExChanger
//
//  Created by Sabbir Ahmed on 25/7/20.
//  Copyright © 2020 Grey Matter. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class HistoryViewController: UIViewController, UITableViewDelegate {
    var context: NSManagedObjectContext!
    @IBOutlet weak var historyTableView: UITableView!
    let viewModel = HistoryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTable()
        bindViewModel()
    }
    
    func initTable() {
        historyTableView.register(HistoryTableViewCell.nib, forCellReuseIdentifier: HistoryTableViewCell.identifier)
        historyTableView.backgroundColor = .white
    
        historyTableView.estimatedRowHeight = 150
        historyTableView.rowHeight = UITableView.automaticDimension
    }
    
    func bindViewModel() {
        historyTableView.delegate = viewModel
        historyTableView.dataSource = viewModel
        historyTableView.reloadData()
    }
   
    
}
