//
//  LoginViewController.swift
//  ModulBankApp
//
//  Created by Анна Мельхова on 22.05.2020.
//  Copyright © 2020 Anna Melkhova. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    //MARK:- IBOutlets:
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet var mainView: UIView!
    let userService = UserService()
    
    //MARK:- didLoad:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(outOfKeyBoardTapped))
        mainView.addGestureRecognizer(tapGesture)
        
        self.emailTextField.keyboardType = UIKeyboardType.emailAddress
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK:- IBActions:
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if checkIfEmpty() {
            // error something is empty
            showAlert(alertTitle: "Ошибка данных", alertMessage: "Заполните все поля, пожалуйста", actionTitle: "Окей")
        }
        else{
            if let email = emailTextField.text{
                if let password = passwordTextField.text{
                    userService.login(email: email, password: password, success: { user in
                        currentUserInfo = user!
                        self.gotoAnotherView(identifier: "TabBarController", sender: self)
                    }) {
                        self.showAlert(alertTitle: "Упс!", alertMessage: "Возникла ошибка при авторизации пользователя, пожалуйста попробуйте снова", actionTitle: "Ок")
                    }
                }
            }
        }
    }
    
    @IBAction func signupButtonPressed(_ sender: UIButton) {
        gotoAnotherView(identifier: "SignupViewController", sender: self)
    }
    
    //MARK:- METHODS:
    
    override func viewWillAppear(_ animated: Bool) {
        emailTextField.text = ""
        passwordTextField.text = ""
        token = ""
        currentUser = User()
        chosenAcc = Account()
    }
    
    func checkIfEmpty() -> Bool {
        if emailTextField.text?.isEmpty == true{
            return true
        }
        if passwordTextField.text?.isEmpty == true{
            return true
        }
        return false
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
