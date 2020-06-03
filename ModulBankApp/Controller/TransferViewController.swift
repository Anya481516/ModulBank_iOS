//
//  TransferViewController.swift
//  ModulBankApp
//
//  Created by Анна Мельхова on 23.05.2020.
//  Copyright © 2020 Anna Melkhova. All rights reserved.
//

import UIKit

protocol TransferDelegate {
    func updateBalance(balance: Int64)
}

class TransferViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet weak var accountToLabel: UITextField!
    @IBOutlet weak var sumTextField: UITextField!
    @IBOutlet weak var newBalanceLabel: UILabel!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var makeTransferButton: UIButton!
    var delegate : TransferDelegate?
    
    let accountService = AccountService()
    
    var accounts = [Int64]()
    var balances = [Int]()
    
    //MARK:- didLoad:
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        newBalanceLabel.text = "\(chosenAcc.balance) Р"
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(outOfKeyBoardTapped))
        mainView.addGestureRecognizer(tapGesture)
        self.sumTextField.keyboardType = UIKeyboardType.numberPad
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func editingChanged(_ sender: Any) {
        if sumTextField.text == "" {
            newBalanceLabel.text = "\(chosenAcc.balance) Р"
        }
        if let sum = Int64(sumTextField.text!){
            newBalanceLabel.text = "\(chosenAcc.balance - sum) Р"
        }
    }
    //MARK:- IBActions:
    @IBAction func makeTransferButtonPressed(_ sender: UIButton) {
        if let sum = Int64(sumTextField.text!){
            if let rAcc = Int64(accountToLabel.text!){
                // transfer
                accountService.transfer(sendingAccId: chosenAcc.id, receivingAccNumber: rAcc, sum: sum, success: {
                    self.showAlertWithAction(alertTitle: "Успех", alertMessage: "Перевод выполнен", actionTitle: "Ок") {
                        self.delegate?.updateBalance(balance: chosenAcc.balance)
                        self.dismiss(animated: true, completion: nil)
                    }
                }) {
                    self.showAlert(alertTitle: "Упс!", alertMessage: "Возникла ошибка при переводе, пожалуйста, попробуйте снова", actionTitle: "Ок")
                }
            }
        }
    }
    
    //MARK:- METHODS:
    
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
