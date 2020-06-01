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
    let userService = UserService()
    
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
            showAlert(alertTitle: "Ошибка данных", alertMessage: "Заполните все поля, пожалуйста", actionTitle: "Окей")
        }
        else{
            if let username = usernameTextField.text{
                if username.count < 3 {
                    // error username has to be at least 3 characters long
                    showAlert(alertTitle: "Ошибка в имени", alertMessage: "Имя пользователя должно содержать по крайней мере 3 символа", actionTitle: "Окей")
                }
                else {
                    if let email = emailTextField.text {
                        if let password1 = password1TextField.text {
                            if let password2 = password2TextField.text {
                                if password1 != password2 {
                                    // error passwords are not the same
                                    showAlert(alertTitle: "Ошибка пароля", alertMessage: "Пароли не совпадают", actionTitle: "Окей")
                                }
                                else{
                                    
                                    // PERFECT!
                                    
                                    userService.signUp(email: email, username: username, password: password1, success: {
                                        print("Новый пользователь был успешно зарегистрирован!" )
                                        //print(value)
                                        self.showAlert(alertTitle: "Добро Пожаловать!", alertMessage: "Вы успешно зарегистрировались. Для входа в приложение пожалуйста авторизируйтесь", actionTitle: "Ок")
                                        self.gotoAnotherView(identifier: "LoginViewController", sender: self)
                                    }) {
                                        self.showAlert(alertTitle: "Упс!", alertMessage: "Возникла ошибка при регистрации пользователя, пожалуйста попробуйте снова", actionTitle: "Ок")
                                        //print(status)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- METHODS:
    
    override func viewWillAppear(_ animated: Bool) {
        usernameTextField.text = ""
        emailTextField.text = ""
        password1TextField.text = ""
        password2TextField.text = ""
        token = ""
        currentUser = User()
        chosenAcc = Account()
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
