//
//  LoginViewController.swift
//  ModulBankApp
//
//  Created by Анна Мельхова on 22.05.2020.
//  Copyright © 2020 Anna Melkhova. All rights reserved.
//

import UIKit
import Alamofire
import  SwiftyJSON

class LoginViewController: UIViewController {

    //MARK:- IBOutlets:
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet var mainView: UIView!
    
    
    private var Manager : Alamofire.SessionManager = {
        // Create the server trust policies
        let serverTrustPolicies: [String: ServerTrustPolicy] = ["http://192.168.0.100:44334/user/login": .disableEvaluation]
        // Create custom manager
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        let man = Alamofire.SessionManager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
        return man
    }()
    
    open class MyServerTrustPolicyManager: ServerTrustPolicyManager {
        open override func serverTrustPolicy(forHost host: String) -> ServerTrustPolicy? {
            return ServerTrustPolicy.disableEvaluation
        }
    }
    let sessionManager = SessionManager(delegate:SessionDelegate(), serverTrustPolicyManager:MyServerTrustPolicyManager(policies: [:]))
    
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
                    //let userService = UserService()
                    
                    //let answer = userService.login(email: email, password: password)
                    
                    let parameters: [String: Any] = [
                        "Email": email,
                        "Password": password
                        ]
                    let url = URL +  "user/login"
                    
                sessionManager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{
                        response in
                        if response.result.isSuccess{
                            // return token
                            if let status = response.response?.statusCode {
                                if status == 200 {
                                    token = JSON(response.result.value!)["token"].stringValue
                                    
                                    print("Вход успешно выполнен!")
                                    print(response.result.description)
                                    print(token)
                                    
                                    // getting the user
                                    let headers = ["Authorization": "Bearer " + token]
                                    let parameters: [String: Any] = [
                                        "Email": email
                                        ]
                                    let url = URL + "user/getByEmail"
                                    
                                    self.sessionManager.request(url, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: headers).responseJSON{
                                        response in
                                        if response.result.isSuccess{
                                            if let status = response.response?.statusCode {
                                                if status == 200 {
                                                    print( "We got the user!!!")
                                                    let userJSON : JSON = JSON(response.result.value!)
                                                    currentUser.id = userJSON["id"].string!
                                                    currentUser.email = userJSON["email"].string!
                                                    currentUser.passwordHash = userJSON["passwordHash"].string!
                                                    currentUser.passwordSalt = userJSON["salt"].string!
                                                    currentUser.username = userJSON["username"].string!
                                                    print(userJSON)
                                                    print(currentUser.id)
                                                    self.gotoAnotherView(identifier: "TabBarController")
                                                }
                                                else {
                                                    print("SERVER ERROR")
                                                }
                                            }
                                        }
                                        else{
                                            print("Ошибка в получении пользователя: \(response.result.error)")
                                        }
                                    }
                                    
                                }
                            }
                        }
                        else{
                            print("Ошибка во входе: \(response.result.error)")
                            print(email, password, url)
                        }
                        
                    }
                    // if the login is successfull
                    //currentUser = User(user: userService.getByEmail(email: email))
                    //token = answer
                    
                    //showAlert(alertTitle: "yo", alertMessage: answer, actionTitle: "ok")
                    // TODO: послать запрос на регу
                    //gotoAnotherView(identifier: "TabBarController")
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
        token = ""
        currentUser = User()
        chosenAcc = Account()
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
