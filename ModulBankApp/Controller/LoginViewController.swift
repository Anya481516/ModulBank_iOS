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
                   
                    // TODO: запрос на вход и получение токена
                    let userService = UserService()
                    
                    let answer = userService.login(email: email, password: password)
                    // if the login is successfull
                    currentUser = User(user: userService.getByEmail(email: email))
                    token = answer
                    
                    showAlert(alertTitle: "yo", alertMessage: answer, actionTitle: "ok")
                    // TODO: послать запрос на регу
                    gotoAnotherView(identifier: "TabBarController")
                }
            }
        }
    }
    
    @IBAction func signupButtonPressed(_ sender: UIButton) {
        gotoAnotherView(identifier: "SignupViewController")
    }
    
    //MARK:- METHODS:
    
    override func viewWillAppear(_ animated: Bool) {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    func gotoAnotherView(identifier: String){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
               let singupVC = storyboard.instantiateViewController(identifier: identifier)
        singupVC.modalPresentationStyle = .fullScreen
        self.dismiss(animated: true) {
            self.present(singupVC, animated: true, completion: nil)
        }
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
    
    // alert
    func showAlert(alertTitle : String, alertMessage : String, actionTitle : String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default) { (UIAlertAction) in
            self.view.layoutIfNeeded()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
