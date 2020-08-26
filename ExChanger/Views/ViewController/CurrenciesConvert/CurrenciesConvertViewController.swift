//
//  CurrenciesConvertViewController.swift
//  ExChanger
//
//  Created by Sabbir Ahmed on 25/7/20.
//  Copyright © 2020 Grey Matter. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import GoogleMobileAds


class CurrenciesConvertViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sourceCurrency: UIButton!
    
    let currenciesViewModel = CurrenciesViewModel()
    let disposeBag = DisposeBag()
    let indicatorView = IndicatorView()
    var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        
        tableView.dataSource = self
        tableView.delegate = self
        
        sourceCurrency.setTitle("1.00  \(currenciesViewModel.source)", for: .normal)
        fatchCurrenciesLive()
    }
    
    @IBAction func pickCurrency(_ sender: Any) {
        if let currencyListViewController = CurrencyListViewController.storyboardInstance() {
            currencyListViewController.delegate = self
            self.present(currencyListViewController, animated: true, completion: nil)
        }
    }
    
    func fatchCurrenciesLive() {
        interstitial = createAndLoadInterstitial()
        indicatorView.showIndicator(parentView: self.view)
        currenciesViewModel.fatchCurrenciesLive()
            .asObservable().subscribe(onNext: { success in
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

extension CurrenciesConvertViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currenciesViewModel.currencyLive.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CurrenciesVonvertTableViewCell.identifier, for: indexPath) as! CurrenciesVonvertTableViewCell
        cell.source = currenciesViewModel.source
        cell.item = currenciesViewModel.currencyLive[indexPath.row]
        return cell
    }
}

extension CurrenciesConvertViewController: CurrenciesConvertDelegate {
    func source(value: String) {
        sourceCurrency.setTitle("1.00  \(value)", for: .normal)
        currenciesViewModel.source = value
        fatchCurrenciesLive()
    }
}

extension CurrenciesConvertViewController: GADInterstitialDelegate {
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: Const.INSTERSTITIAL_AD_UNIT_ID)
      interstitial.delegate = self
      interstitial.load(GADRequest())
      return interstitial
    }
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        loadAds()
    }
    
    func loadAds() {
        if interstitial.isReady {
          interstitial.present(fromRootViewController: self)
        }
    }
}
