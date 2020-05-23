//
//  InvoiceViewController.swift
//  ModulBankApp
//
//  Created by Анна Мельхова on 23.05.2020.
//  Copyright © 2020 Anna Melkhova. All rights reserved.
//

import UIKit

class InvoiceViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    //MARK:- IBOutlets:
    @IBOutlet weak var accountPicker: UIPickerView!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var date1Picker: UIDatePicker!
    @IBOutlet weak var date2Picker: UIDatePicker!
    
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
    }
    
    //MARK:- IBActions:
    @IBAction func showInvoiceButtonPressed(_ sender: Any) {
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
}
