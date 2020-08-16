import Foundation
import UIKit
import CoreData
import RxSwift
import RxDataSources
import GoogleMobileAds


class HistoryViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
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
        showAds()
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

extension HistoryViewController: GADBannerViewDelegate {
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
      bannerView.alpha = 0
      UIView.animate(withDuration: 0.6, animations: {
        bannerView.alpha = 1
      })
    }
    
    func showAds() {
        // アドモブのバナー表示
        bannerView.delegate = self
        bannerView.adUnitID = Const.TOP_BANNER_AD_UNIT_ID
        bannerView.rootViewController = self
        bannerRequest()
    }
    
    /*
     * 広告のリクエストを送信
     */
    func bannerRequest() {
        bannerView.load(GADRequest())
    }
}
