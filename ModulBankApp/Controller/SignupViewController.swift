//
//  SignupViewController.swift
//  ModulBankApp
//
//  Created by Анна Мельхова on 22.05.2020.
//  Copyright © 2020 Anna Melkhova. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SignupViewController: UIViewController {

    //MARK:- IBOutlets:
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var password1TextField: UITextField!
    @IBOutlet weak var password2TextField: UITextField!
    @IBOutlet var mainView: UIView!
    
    open class MyServerTrustPolicyManager: ServerTrustPolicyManager {
        open override func serverTrustPolicy(forHost host: String) -> ServerTrustPolicy? {
            return ServerTrustPolicy.disableEvaluation
        }
    }
    let sessionManager = SessionManager(delegate:SessionDelegate(), serverTrustPolicyManager:MyServerTrustPolicyManager(policies: [:]))
    
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
                                    let user = User(username: username, email: email, password: password1)
                                    
                                    //let userService = UserService()
                                    //let answer = userService.signUp(email: email, username: username, password: password1)
                                    
                                    //showAlert(alertTitle: "yo", alertMessage: answer, actionTitle: "ok")
                                    // TODO: послать запрос на регу
                                    //gotoAnotherView(identifier: "LoginViewController")
                                    
                                    var answer = "some error"
                                    let parameters: [String: Any] = [
                                        "Email": email,
                                        "Username": username,
                                        "Password": password1
                                        ]
                                    //let url2 = "http://api.openweathermap.org/data/2.5/weather"
                                    let url = "https://192.168.0.100:44334/user/signup"
                                    
                                    sessionManager.request(url, method: .post, parameters: parameters).responseJSON{
                                        response in
                                        if response.result.isSuccess{
                                            print("Новый пользователь был успешно зарегистрирован!" )
                                        }
                                        else{
                                            print("Ошибка в регистрации: \(response.result.error)")
                                        }
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
