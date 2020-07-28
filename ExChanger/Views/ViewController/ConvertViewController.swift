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

class ConvertViewController: UIViewController {
    
    @IBOutlet var currencyButtons: [UIButton]!
    @IBOutlet weak var inputAmountFirst: UILabel!
    @IBOutlet weak var inputAmountSecond: UILabel!
    
    let convertViewModel = ConvertViewModel()
    let indicatorView = IndicatorView()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        
        let tapInputAmountFirst = UITapGestureRecognizer(target: self, action: #selector(clickInputAmountFirst))
        inputAmountFirst.isUserInteractionEnabled = true
        inputAmountFirst.addGestureRecognizer(tapInputAmountFirst)
        
        let tapInputAmountSecond = UITapGestureRecognizer(target: self, action: #selector(clickInputAmountSecond))
        inputAmountSecond.isUserInteractionEnabled = true
        inputAmountSecond.addGestureRecognizer(tapInputAmountSecond)
        
        updateInputFocuse()
        
        setCurrencyButtonTitle()
    }
    
    @IBAction func pickCurrency(_ sender: UIButton) {
        convertViewModel.currencyTag = sender.tag
        
        if let currencyListViewController = CurrencyListViewController.storyboardInstance() {
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
            inputAmountFirst.textColor = UIColor.black
            inputAmountFirst.font = UIFont.systemFont(ofSize: 44)
        } else {
            inputAmountFirst.textColor = UIColor.gray
            inputAmountFirst.font = UIFont.systemFont(ofSize: 36)
        }
        
        if inputAmountSecond.tag == convertViewModel.inputValueTag {
            inputAmountSecond.textColor = UIColor.black
            inputAmountSecond.font = UIFont.systemFont(ofSize: 44)
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
  
  func saveConversion(dt: Date, bk: String, bv: Float, tk: String, tv: Float) {
        let sharedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let appDel = (UIApplication.shared.delegate as! AppDelegate)
        //インスタンス化をする
        let dict = [
            "dateTime": dt,
            "baseKeyName": bk,
            "baseValue": bv,
            "targetKeyName": tk,
            "targetValue": tv
        ] as [String : Any]
        _ = HistoryModel(dictionary: dict as [String : AnyObject], context: sharedContext)
        appDel.saveContext()
        print("save contents.............")
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
    }
}
