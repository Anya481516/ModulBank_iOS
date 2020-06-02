//
//  OpenNewAccountViewController.swift
//  ModulBankApp
//
//  Created by Анна Мельхова on 23.05.2020.
//  Copyright © 2020 Anna Melkhova. All rights reserved.
//

import  UIKit
import Alamofire
import SwiftyJSON

class OpenNewAccountViewController: UIViewController {

    //MARK:- IBOutlets:
    @IBOutlet weak var balanceTextFiewl: UITextField!
    @IBOutlet var mainView: UIView!
    
    let accountService = AccountService()

    
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(outOfKeyBoardTapped))
        mainView.addGestureRecognizer(tapGesture)
        
        self.balanceTextFiewl.keyboardType = UIKeyboardType.numberPad
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
       
    }
    
    //MARK:- IBActions:
    @IBAction func openNewAccountButtonPressed(_ sender: Any) {
        if let balance = Int64(balanceTextFiewl.text!) {
            let headers = ["Authorization": "Bearer " + token]
            let parameters: [String: Any] = [
                "UserId": currentUser.id,
                "Balance": balance
                ]
            let url = URL + "account/openNew"
            
            self.sessionManager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON{
                response in
                    if let status = response.response?.statusCode {
                        if status == 200{
                            print("Аккаунт создан")
                            
                            currentUserAccounts = [Account]()
                            let parameters2: [String: Any] = [
                                       "UserId": currentUser.id
                                       ]
                            let url2 = URL + "user/getAccounts"
                            
                            self.sessionManager.request(url2, method: .post, parameters: parameters2, encoding: JSONEncoding.default, headers: headers).responseJSON{
                                response in
                                    if let status = response.response?.statusCode {
                                        if status == 200{
                                            let accountsJSON : JSON = JSON(response.result.value!)
                                            print("счетазагружены")
                                            var accNumber: Int64 = 123
                                            for n in 0...accountsJSON.count-1 {
                                                accNumber = (accountsJSON[n]["accNumber"].int64!)
                                                let accBalance = (accountsJSON[n]["balance"].int64!)
                                                let accId = accountsJSON[n]["id"].string!
                                                let uId = accountsJSON[n]["userId"].string!
                                                let acc = Account(id: accId, userId: uId, number: accNumber, balance: accBalance)
                                                currentUserAccounts.append(acc)
                                            }
                                            print(currentUserAccounts[0].id, currentUserAccounts[0].balance, currentUserAccounts[0].number, currentUserAccounts[0].userId)
                                        }
                                        else {
                                            self.showAlert(alertTitle: "Упс!", alertMessage: "Возникла ошибка при загрузке счетов", actionTitle: "Ок")
                                            print(status)
                                           
                                        }
                                    }
                                    //}
                                    else {
                                    print(response.error)
                                    print(currentUser.id)
                                }
                            }
                            self.dismiss(animated: true, completion: nil)
                        }
                        else {
                            self.showAlert(alertTitle: "Упс!", alertMessage: "Возникла ошибка при создании счета, пожалуйста, попробуйте снова", actionTitle: "Ок")
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
