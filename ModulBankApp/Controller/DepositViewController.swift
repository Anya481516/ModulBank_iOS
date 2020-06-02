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
    
    let accountService = AccountService()
    
    var sum = Int64()
    
    //MARK:- didLoad:
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        newBalanceLabel.text = "\(chosenAcc.balance) Р"
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(outOfKeyBoardTapped))
        mainView.addGestureRecognizer(tapGesture)
        self.sumTextFiewld.keyboardType = UIKeyboardType.numberPad
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    //MARK:- IBActions:

    @IBAction func editingChanged(_ sender: Any) {
        if sumTextFiewld.text == "" {
            newBalanceLabel.text = "\(chosenAcc.balance) Р"
        }
        if let sum = Int64(sumTextFiewld.text!){
            newBalanceLabel.text = "\(chosenAcc.balance + sum) Р"
        }
    }
    
    @IBAction func makeDepositButtonPressed(_ sender: UIButton) {
        if let sum = Int64(sumTextFiewld.text!){
            accountService.deposit(uid: currentUser.id, accId: chosenAcc.id, sum: sum, success: {
                self.showAlertWithAction(alertTitle: "Успех!", alertMessage: "Платеж проведен!", actionTitle: "Ок") {
                    self.dismiss(animated: true, completion: nil)
                }
            }) {
                self.showAlert(alertTitle: "Упс!", alertMessage: "Возникла ошибка при создании счета, пожалуйста, попробуйте снова", actionTitle: "Ок")
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

