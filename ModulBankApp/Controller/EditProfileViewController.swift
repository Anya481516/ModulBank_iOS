//
//  EditProfileViewController.swift
//  ModulBankApp
//
//  Created by Анна Мельхова on 23.05.2020.
//  Copyright © 2020 Anna Melkhova. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class EditProfileViewController: UIViewController {

    //MARK:- IBOutlets:
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
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
        // Do any additional setup after loading the view.
        
        self.emailTextField.keyboardType = UIKeyboardType.emailAddress
        
        emailTextField.text = currentUser.email
        usernameTextField.text = currentUser.username
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(outOfKeyBoardTapped))
        mainView.addGestureRecognizer(tapGesture)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK:- IBActions:
    @IBAction func saveChangesButtonPressed(_ sender: Any) {
    }
    @IBAction func changePasswordButtonPressed(_ sender: Any) {
    }
    @IBAction func changePhotoButtonPressed(_ sender: Any) {
    }
    @IBAction func deleteUserButtonPressed(_ sender: Any) {
        let headers = ["Authorization": "Bearer " + token]
        let parameters: [String: Any] = [
            "UserId": currentUser.id
            ]
        let url = URL + "user/delete"
        
        let alert = UIAlertController(title: "Удаление!", message: "Вы уверенны что хотите удалить ваш аккаунт?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Да", style: .default) { (UIAlertAction) in
            print(currentUser.id)
            self.sessionManager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON{
                response in
                    if let status = response.response?.statusCode {
                        if status == 200{
                            print("Ваш аккаунт был успешно удален")
                               //print(value)
                               //self.showAlert(alertTitle: "Мы будем скучать!", alertMessage: "Ваш аккаунт был успешно удален", actionTitle: "Ок")
                            self.clearHistory()
                            
                            self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                               
                        }
                        else {
                            self.showAlert(alertTitle: "Упс!", alertMessage: "Возникла ошибка при удалении пользователя, пожалуйста, попробуйте снова", actionTitle: "Ок")
                            print(status)
                           
                        }
                    }
                    //}
                    else {
                    print(response.error)
                    print(currentUser.id)
                }
            }
        }
        let actionYes = UIAlertAction(title:"Нет", style: .cancel) { (UIAlertAction) in
            
        }
        alert.addAction(action)
        alert.addAction(actionYes)
        self.present(alert, animated: true, completion: nil)
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
    
    func gotoAnotherView(identifier: String){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
               let singupVC = storyboard.instantiateViewController(identifier: identifier)
        singupVC.modalPresentationStyle = .fullScreen
        self.dismiss(animated: true) {
            self.present(singupVC, animated: true, completion: nil)
        }
    }
    
    func clearHistory(){
        token = ""
        chosenAcc = Account()
        currentUser = User()
    }
}
