//
//  DepositViewController.swift
//  ModulBankApp
//
//  Created by Анна Мельхова on 23.05.2020.
//  Copyright © 2020 Anna Melkhova. All rights reserved.
//

import UIKit

class DepositViewController: UIViewController {

    //MARK:- IBOutlets:
    @IBOutlet weak var sumTextFiewld: UITextField!
    @IBOutlet weak var newBalanceLabel: UILabel!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var makeDepositButton: UIButton!
    
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
    @IBAction func makeDepositButtonPressed(_ sender: UIButton) {
    }
    @IBAction func makeTransferButtonPressed(_ sender: Any) {
    }
    @IBAction func makePaymentButtonPressed(_ sender: Any) {
    }
    
    //MARK:- METHODS:
    

}
