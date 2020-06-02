//
//  AccountDetailsViewController.swift
//  ModulBankApp
//
//  Created by Анна Мельхова on 30.05.2020.
//  Copyright © 2020 Anna Melkhova. All rights reserved.
//

import UIKit

class AccountDetailsController: UIViewController, DepositDelegate, TransferDelegate, PaymentDelegate {
    func updateBalance(balance: Int64) {
        accountBalanceLabel.text = "\(balance) рублей"
    }

    //MARK:- IBOutlets:
    @IBOutlet weak var accountNumberLabel: UILabel!
    @IBOutlet weak var accountBalanceLabel: UILabel!
    
    //MARK:- didLoad:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accountNumberLabel.text = String(chosenAcc.number)
        accountBalanceLabel.text = "\(chosenAcc.balance) рублей"
        // Do any additional setup after loading the view.
    }
    
    //MARK:- IBActions:
    @IBAction func depositButtonPressed(_ sender: Any) {
    }
    @IBAction func transferButtonPressed(_ sender: Any) {
    }
    @IBAction func paymentButtonPressed(_ sender: Any) {
    }
    
    //MARK:- METHODS:
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromDetailsToDeposit", let destinationVC = segue.destination as? DepositViewController {
            destinationVC.delegate = self
        }
        if segue.identifier == "fromDetailsToTransfer", let destinationVC = segue.destination as? TransferViewController {
            destinationVC.delegate = self
        }
        if segue.identifier == "fromDetailsToPaymenr", let destinationVC = segue.destination as? PayViewController {
            destinationVC.delegate = self
        }
    }
}
