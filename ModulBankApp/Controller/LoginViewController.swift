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
        }
        else{
            if let email = emailTextField.text{
                if let password = passwordTextField.text{
                    let user = User(email: email, password: password)
                    // TODO: запрос на вход и получение токена
                    gotoAnotherView(identifier: "TabBarController")
                }
                else {
                    //error smth s wrong with password
                }
            }
            else{
                // error smth is wrong with email
            }
        }
    }
    
    @IBAction func signupButtonPressed(_ sender: UIButton) {
        gotoAnotherView(identifier: "SignupViewController")
    }
    
    //MARK:- METHODS:
    
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
}
