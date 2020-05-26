//
//  InvoiceViewController.swift
//  ModulBankApp
//
//  Created by Анна Мельхова on 23.05.2020.
//  Copyright © 2020 Anna Melkhova. All rights reserved.
//

import UIKit

class DateChooseViewController: UIViewController {

    //MARK:- IBOutlets:
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
    }
    
    //MARK:- IBActions:
    @IBAction func showInvoiceButtonPressed(_ sender: Any) {
    }
    
    //MARK:- METHODS:

}
