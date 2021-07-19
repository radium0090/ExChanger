//
//  ConvertViewController.swift
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
import AppTrackingTransparency

class ConvertViewController: UIViewController {
    
    @IBOutlet var currencyButtons: [UIButton]!
    @IBOutlet weak var inputAmountFirst: UILabel!
    @IBOutlet weak var inputAmountSecond: UILabel!
    @IBOutlet weak var bannerView: GADBannerView!
    
    let convertViewModel = ConvertViewModel()
    let indicatorView = IndicatorView()
    let disposeBag = DisposeBag()
    var interstitial: GADInterstitial!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkATT()
    }
    
    override func viewDidLoad() {
        
        let tapInputAmountFirst = UITapGestureRecognizer(target: self, action: #selector(clickInputAmountFirst))
        inputAmountFirst.isUserInteractionEnabled = true
        inputAmountFirst.addGestureRecognizer(tapInputAmountFirst)
        
        let tapInputAmountSecond = UITapGestureRecognizer(target: self, action: #selector(clickInputAmountSecond))
        inputAmountSecond.isUserInteractionEnabled = true
        inputAmountSecond.addGestureRecognizer(tapInputAmountSecond)
        
        updateInputFocuse()
        setCurrencyButtonTitle()
        showAds()
    }
    
    @IBAction func pickCurrency(_ sender: UIButton) {
        convertViewModel.currencyTag = sender.tag
            if let currencyListViewController = CurrencyListViewController.storyboardInstance() {
            currencyListViewController.sourceConvertionCode = convertViewModel.currencyName[0]
            currencyListViewController.delegate = self
            self.present(currencyListViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func appendNumber(_ sender: UIButton) {
        
        var value = String()
        if convertViewModel.currencyValue[convertViewModel.inputValueTag] == "0" {
            value = String(sender.tag)
        } else {
            value = String("\(convertViewModel.currencyValue[convertViewModel.inputValueTag])\( sender.tag)")
        }
        convertViewModel.currencyValue[convertViewModel.inputValueTag] = value
        updateInputValue()
    }
    
    @IBAction func addDecimalValue(_ sender: Any) {
        if convertViewModel.currencyValue[convertViewModel.inputValueTag] != "0" {
            var value = String(convertViewModel.currencyValue[convertViewModel.inputValueTag])
            if !value.contains(".") {
                value.append(".")
                convertViewModel.currencyValue[convertViewModel.inputValueTag] = value
                updateInputValue()
            }
        }
    }
    
    @IBAction func cleanInputValue(_ sender: Any) {
        for index in 0...1 {
            convertViewModel.currencyValue[index] = "0"
        }
        updateInputValue()
    }
    
    @IBAction func deleatLastInput(_ sender: Any) {
        if convertViewModel.currencyValue[convertViewModel.inputValueTag] != "0" {
            var value = String(convertViewModel.currencyValue[convertViewModel.inputValueTag])
            if value.count > 1 {
                
                value.remove(at: value.index(before: value.endIndex))
                convertViewModel.currencyValue[convertViewModel.inputValueTag] = value
                updateInputValue()
            }
            
        }
    }
    
    @IBAction func convertInput(_ sender: Any) {
        if convertViewModel.currencyValue[convertViewModel.inputValueTag] != "0" {
            indicatorView.showIndicator(parentView: self.view)
            convertViewModel.fatchCurrencyConvert()
                .asObservable()
                .subscribe(onNext: { success in
                    if success {
                        DispatchQueue.main.async {
                            self.updateInputFocuse()
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
    
    func setCurrencyButtonTitle() {
        for buttonTitle in currencyButtons {
            buttonTitle.setTitle(convertViewModel.currencyName[buttonTitle.tag], for: .normal)
        }
    }
    
    @objc
    func clickInputAmountFirst(sender: UITapGestureRecognizer) {
        if convertViewModel.inputValueTag != 0 {
            convertViewModel.inputValueTag = 0
            convertViewModel.currencyValue[1] = "0"
            updateInputFocuse()
        }
    }
    
    @objc
    func clickInputAmountSecond(sender:UITapGestureRecognizer) {
        if convertViewModel.inputValueTag != 1 {
            convertViewModel.inputValueTag = 1
            convertViewModel.currencyValue[0] = "0"
            updateInputFocuse()
        }
    }
    
    func updateInputFocuse() {
        
        if inputAmountFirst.tag == convertViewModel.inputValueTag {
            inputAmountFirst.textColor = UIColor.init(named: "inputAmopuntLabelTextColor")
            inputAmountFirst.font = UIFont.systemFont(ofSize: 48)
        } else {
            inputAmountFirst.textColor = UIColor.init(named: "inputAmopuntLabelTextColor")
            inputAmountFirst.font = UIFont.systemFont(ofSize: 36)
        }
        
        if inputAmountSecond.tag == convertViewModel.inputValueTag {
            inputAmountSecond.textColor = UIColor.black
            inputAmountSecond.font = UIFont.systemFont(ofSize: 48)
        } else {
            inputAmountSecond.textColor = UIColor.gray
            inputAmountSecond.font = UIFont.systemFont(ofSize: 36)
        }
        
        updateInputValue()
    }
    
    func updateInputValue() {
        inputAmountFirst.text = convertViewModel.currencyValue[0]
        inputAmountSecond.text = convertViewModel.currencyValue[1]
    }
    
    func checkATT() {
        if #available(iOS 14, *) {
            switch ATTrackingManager.trackingAuthorizationStatus {
            case .authorized:
                print("Allow Tracking")
            case .denied:
                print("Denided")
            case .restricted:
                print("Limited")
            case .notDetermined:
                showRequestTrackingAuthorizationAlert()
            @unknown default:
                fatalError()
            }
        } else {
            print("Nothing implement")
        }
    }
    
    private func showRequestTrackingAuthorizationAlert() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                switch status {
                case .authorized:
                    print("can get IDFA")
                case .denied, .restricted, .notDetermined:
                    print("no way")
                @unknown default:
                    fatalError()
                }
            })
        }
    }
}

extension ConvertViewController: CurrenciesConvertDelegate {
    func source(value: String) {
        
        convertViewModel.currencyName[convertViewModel.currencyTag] = value
        
        for index in 0...1 {
            convertViewModel.currencyValue[index] = "0"
        }
        
        setCurrencyButtonTitle()
        updateInputValue()
        
        interstitial = createAndLoadInterstitial()
    }
}

extension ConvertViewController: GADBannerViewDelegate {
    
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

extension ConvertViewController: GADInterstitialDelegate {
    
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

