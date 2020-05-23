//
//  TransferViewController.swift
//  ModulBankApp
//
//  Created by Анна Мельхова on 23.05.2020.
//  Copyright © 2020 Anna Melkhova. All rights reserved.
//

import UIKit

class TransferViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    //MARK:- IBOutlets
    @IBOutlet weak var accountPicker: UIPickerView!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var accountToLabel: UITextField!
    @IBOutlet weak var sumLabel: UITextField!
    @IBOutlet weak var newBalanceLabel: UILabel!
    @IBOutlet var mainView: UIView!
    
    var accounts = [Int64]()
       var balances = [Int]()
    
    //MARK:- didLoad:
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        accounts = [4000000000, 4000000001, 4000000002]
        balances = [2013, 1230, 20404]
        
        self.accountPicker.delegate = self
        self.accountPicker.dataSource = self
        
        balanceLabel.text = String(balances[0])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(outOfKeyBoardTapped))
        mainView.addGestureRecognizer(tapGesture)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK:- IBActions:
    @IBAction func makeTransferButtonPressed(_ sender: UIButton) {
    }
    
    //MARK:- METHODS:
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return accounts.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(accounts[row])
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //
        balanceLabel.text = String(balances[pickerView.selectedRow(inComponent: 0)])
    }
    
    // with the keyboard
    @objc func outOfKeyBoardTapped(){
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= (keyboardSize.height - 80)
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

}

