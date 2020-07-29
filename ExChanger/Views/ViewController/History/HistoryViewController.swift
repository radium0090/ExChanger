import Foundation
import UIKit
import CoreData
import RxSwift
import RxDataSources


class HistoryViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    private var viewModel: HistoryViewModel!
    private var disposeBag = DisposeBag()
    // load with rxdatasource
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
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(HistoryTableViewCell.nib, forCellReuseIdentifier: HistoryTableViewCell.identifier)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    // bind viewModel
    private func setupViewModel() {
        viewModel = HistoryViewModel()
        viewModel.items
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        viewModel.updateItem()
    }
}
