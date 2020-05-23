//
//  AcountViewController.swift
//  ModulBankApp
//
//  Created by Анна Мельхова on 22.05.2020.
//  Copyright © 2020 Anna Melkhova. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK:- IBOutlets:
    @IBOutlet weak var accountPickerView: UIPickerView!
    @IBOutlet weak var accountBalanceLabel: UILabel!
    
    var accounts = [Int64]()
    var balances = [Int]()
    
    //MARK:- didLoad:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // TODO: define the accounts
        accounts = [4000000000, 4000000001, 4000000002]
        balances = [2013, 1230, 20404]
        
        self.accountPickerView.delegate = self
        self.accountPickerView.dataSource = self
        
        accountBalanceLabel.text = String(balances[0])
//        accountPickerView.delegate = accountPickerDelegate
//        accountPickerView.dataSource = accountPickerDelegate
//
//        operationPickerView.delegate = operationPickerDelegate
//        operationPickerView.dataSource = operationPickerDelegate
    }
    
    //MARK:- IBActions:
    @IBAction func openNewAccountButtonPressed(_ sender: UIButton) {
    }
    @IBAction func depositButtonPressed(_ sender: Any) {
    }
    @IBAction func transferButtonPressed(_ sender: Any) {
    }
    @IBAction func payButtonPressed(_ sender: Any) {
    }
    @IBAction func invoiceButtonPressed(_ sender: Any) {
    }
    @IBAction func sampleButtonPressed(_ sender: Any) {
    }
    @IBAction func closeAccountPressed(_ sender: Any) {
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
        accountBalanceLabel.text = String(balances[pickerView.selectedRow(inComponent: 0)])
    }
    
}
