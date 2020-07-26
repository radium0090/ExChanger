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
import RxSwift
import RxDataSources


class HistoryViewController: UIViewController, UITableViewDelegate {
    // bound with ViewModel
    @IBOutlet weak var historyTableView: UITableView!
    private var viewModel: HistoryViewModel!
    private var disposeBag = DisposeBag()
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<SectionOfConversion>(configureCell: configureCell, titleForHeaderInSection: titleForHeaderInSection)
    private lazy var configureCell: RxTableViewSectionedReloadDataSource<SectionOfConversion>.ConfigureCell = { [weak self] (dataSource, tableView, indexPath, conversion) in
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.identifier, for: indexPath) as! HistoryTableViewCell
        cell.setCell(dt: conversion.dateTime,
                     bk: conversion.baseKeyName,
                     bv: conversion.baseValue,
                     tk: conversion.targetKeyName,
                     tv: conversion.targetValue)
        return cell
    }
    private lazy var titleForHeaderInSection: RxTableViewSectionedReloadDataSource<SectionOfConversion>.TitleForHeaderInSection = { [weak self] (dataSource, indexPath) in
        return dataSource.sectionModels[indexPath].header
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupTableView()
        setupViewModel()
    }

}

extension HistoryViewController {
    // page title acan add more configs
    private func setupViewController() {
        self.title = "History"
    }
    
    // tableview setup
    private func setupTableView() {
        historyTableView.estimatedRowHeight = 180
        historyTableView.rowHeight = UITableView.automaticDimension
        historyTableView.register(HistoryTableViewCell.nib, forCellReuseIdentifier: HistoryTableViewCell.identifier)
        historyTableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    // bind viewModel
    private func setupViewModel() {
        viewModel = HistoryViewModel()
        viewModel.items
            .bind(to: historyTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        viewModel.updateItem()
    }
}
