//
//  PayViewController.swift
//  ModulBankApp
//
//  Created by Анна Мельхова on 23.05.2020.
//  Copyright © 2020 Anna Melkhova. All rights reserved.
//

import UIKit

class PayViewController: UIViewController, SampleDelegate {
    
    func fillInfo(name: String, email: String, sum: Int64) {
        sumTextField.text = "\(sum)"
        nameTextField.text = name
        placeToLabel.text = email
        newBalanceLabel.text = "\(chosenAcc.balance - sum) P"
    }

    //MARK:- IBOutlets:
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var placeToLabel: UITextField!
    @IBOutlet weak var sumTextField: UITextField!
    @IBOutlet weak var newBalanceLabel: UILabel!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var makePaymentButton: UIButton!
    
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
    @IBAction func makePayButtonPressed(_ sender: Any) {
        if let sum = Int64(sumTextField.text!){
            if let name = nameTextField.text{
                if let email = placeToLabel.text{
                    accountService.payment(name: name, email: email, sum: sum, success: {
                        self.showAlertWithAction(alertTitle: "Успех", alertMessage: "Платеж выполнен", actionTitle: "Ок") {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }) {
                        self.showAlert(alertTitle: "Упс!", alertMessage: "Возникла ошибка при проведении платежа, пожалуйста, попробуйте снова", actionTitle: "Ок")
                    }
                }
            }
        }
    }
    
    @IBAction func saveSampleButtonPressed(_ sender: Any) {
        if let sum = Int64(sumTextField.text!){
        if let name = nameTextField.text{
            if let email = placeToLabel.text{
                accountService.saveToSamples(name: name, email: email, sum: sum, success: {
                    self.showAlert(alertTitle: "Готово", alertMessage: "Ваш шаблон успешно сохранен!", actionTitle: "Ок")
                }) {
                    self.showAlert(alertTitle: "Упс!", alertMessage: "Что-то не так с шаблоном!", actionTitle: "Ок =(")
                }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromPaymentToSamples", let destinationVC = segue.destination as? SampleViewController {
            destinationVC.delegate = self
        }
    }
}

