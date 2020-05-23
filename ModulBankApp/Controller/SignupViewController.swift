//
//  SignupViewController.swift
//  ModulBankApp
//
//  Created by Анна Мельхова on 22.05.2020.
//  Copyright © 2020 Anna Melkhova. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {

    //MARK:- IBOutlets:
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var password1TextField: UITextField!
    @IBOutlet weak var password2TextField: UITextField!
    @IBOutlet var mainView: UIView!
    
    //MARK:- didLoad:
    override func viewDidLoad() {
        super.viewDidLoad()

        self.emailTextField.keyboardType = UIKeyboardType.emailAddress
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(outOfKeyBoardTapped))
        mainView.addGestureRecognizer(tapGesture)
        
        self.emailTextField.keyboardType = UIKeyboardType.emailAddress
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK:- IBActions:
    @IBAction func signuoButtonPressed(_ sender: UIButton) {
        if checkIfEmpty() {
            // error something is empty
        }
        else{
            if let username = usernameTextField.text{
                if username.count < 3 {
                    // error username has to be at least 3 characters long
                }
                else {
                    if let email = emailTextField.text {
                        if let password1 = password1TextField.text {
                            if let password2 = password2TextField.text {
                                if password1 != password2 {
                                    // error passwords are not the same
                                }
                                else{
                                    // PERFECT!
                                    let user = User(username: username, email: email, password: password1)
                                    // TODO: послать запрос на регу
                                    gotoAnotherView(identifier: "TabBarController")
                                }
                            }
                        }
                    }
                    else {
                        // error with email
                    }
                }
            }
            else {
                //error somwthing is wrong with username
            }
        }
        
    }
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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
        if usernameTextField.text?.isEmpty == true{
            return true
        }
        if emailTextField.text?.isEmpty == true{
            return true
        }
        if password1TextField.text?.isEmpty == true{
            return true
        }
        if password2TextField.text?.isEmpty == true{
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
