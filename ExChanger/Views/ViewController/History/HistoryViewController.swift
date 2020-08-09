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
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<SectionOfConversion>(configureCell: configureCell, titleForHeaderInSection: titleForHeaderInSection, canEditRowAtIndexPath: canEditRowAtIndexPath)
    private lazy var configureCell: RxTableViewSectionedReloadDataSource<SectionOfConversion>.ConfigureCell = { [weak self] (dataSource, tableView, indexPath, conversion) in
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.identifier, for: indexPath) as! HistoryTableViewCell
        cell.setCell(dt: conversion.dateTime!,
                     bk: conversion.baseKeyName!,
                     bv: conversion.baseValue,
                     tk: conversion.targetKeyName!,
                     tv: conversion.targetValue)
        return cell
    }
    private lazy var titleForHeaderInSection: RxTableViewSectionedReloadDataSource<SectionOfConversion>.TitleForHeaderInSection = { [weak self] (dataSource, indexPath) in
        return dataSource.sectionModels[indexPath].header
    }
    private lazy var canEditRowAtIndexPath: RxTableViewSectionedReloadDataSource<SectionOfConversion>.CanEditRowAtIndexPath = { _, _ in
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupTableView()
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.updateItem()
    }
}

extension HistoryViewController {
    // page title acan add more configs
    private func setupViewController() {
        self.title = "Conversion History"
    }
    
    // tableview setup
    private func setupTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(HistoryTableViewCell.nib, forCellReuseIdentifier: HistoryTableViewCell.identifier)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        tableView.rx.itemDeleted.subscribe({ [unowned self] act in
            let alert = UIAlertController(title: "Confirm to delete",
                                          message: "Are you sure to delete this history section?",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action: UIAlertAction) in
                guard let indexPath = act.element else { return }
                CoreDataClient.shared.removeConversion(at: indexPath.row)
                self.viewModel.updateItem()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }).disposed(by: disposeBag)
    }
    
    // bind viewModel
    private func setupViewModel() {
        viewModel = HistoryViewModel()
        viewModel.items
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}
