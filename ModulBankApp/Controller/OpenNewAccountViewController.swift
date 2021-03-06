//
//  OpenNewAccountViewController.swift
//  ModulBankApp
//
//  Created by Анна Мельхова on 23.05.2020.
//  Copyright © 2020 Anna Melkhova. All rights reserved.
//

import  UIKit

class OpenNewAccountViewController: UIViewController {

    //MARK:- PROPERTIES:
    let accountService = AccountService()
    
    //MARK:- IBOutlets:
    @IBOutlet weak var balanceTextFiewl: UITextField!
    @IBOutlet var mainView: UIView!
    
    //MARK:- didLoad:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(outOfKeyBoardTapped))
        mainView.addGestureRecognizer(tapGesture)
        
        self.balanceTextFiewl.keyboardType = UIKeyboardType.numberPad
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK:- IBActions:
    @IBAction func openNewAccountButtonPressed(_ sender: Any) {
        if let balance = Int64(balanceTextFiewl.text!) {
            
            accountService.openNew(uid: currentUserInfo.id, balance: balance, success: {
                self.dismiss(animated: true, completion: nil)
            }) {
                 self.showAlert(alertTitle: "Упс!", alertMessage: "Возникла ошибка при создании счета, пожалуйста, попробуйте снова", actionTitle: "Ок")
            }
        }
    }
    
    //MARK:- METHODS:
    
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
