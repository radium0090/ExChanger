//
//  CurrencyListViewController.swift
//  ExChanger
//
//  Created by Sabbir Ahmed on 25/7/20.
//  Copyright © 2020 Grey Matter. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol CurrenciesConvertDelegate {
    func source(value: String)
}


class CurrencyListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var curencyListViewModel = CurrencyListViewModel()
    let disposeBag = DisposeBag()
    let indicatorView = IndicatorView()
    var delegate : CurrenciesConvertDelegate?
    
    override func viewDidLoad() {
        
        tableView.dataSource = self
        tableView.delegate = self
        
        indicatorView.showIndicator(parentView: self.view)
        
        curencyListViewModel.fatchCurrencies()
            .asObservable()
            .subscribe(onNext: { success in
                if success {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.indicatorView.removeIndicator()
                    }
                }
            }, onError: { error in
                DispatchQueue.main.async {
                    self.indicatorView.removeIndicator()
                }
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}

extension CurrencyListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        curencyListViewModel.sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return curencyListViewModel.sectionTitles[section]
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return curencyListViewModel.sectionTitles
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let key = curencyListViewModel.sectionTitles[section]
        guard let sectionValues = curencyListViewModel.currenciesDictionary[key] else { return 0 }
        
        return sectionValues.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyListTableViewCell.identifier, for: indexPath) as! CurrencyListTableViewCell
        
        let key = curencyListViewModel.sectionTitles[indexPath.section]
        if let sectinValues = curencyListViewModel.currenciesDictionary[key] {
            cell.item = sectinValues[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let key = curencyListViewModel.sectionTitles[indexPath.section]
        if let sectinValues = curencyListViewModel.currenciesDictionary[key] {
            let currency = sectinValues[indexPath.row].currency
            self.delegate?.source(value: currency)
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension CurrencyListViewController {
    static func storyboardInstance() -> CurrencyListViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "CurrencyListViewController") as? CurrencyListViewController
    }
}

