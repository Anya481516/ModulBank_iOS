//
//  HomeViewController.swift
//  ModulBankApp
//
//  Created by Анна Мельхова on 22.05.2020.
//  Copyright © 2020 Anna Melkhova. All rights reserved.
//

import UIKit
import  Alamofire
import SwiftyJSON

class HomeViewController: UIViewController {

    //MARK:- IBOutlets:
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var totalBalanceLabel: UILabel!
    
    open class MyServerTrustPolicyManager: ServerTrustPolicyManager {
           open override func serverTrustPolicy(forHost host: String) -> ServerTrustPolicy? {
               return ServerTrustPolicy.disableEvaluation
           }
       }
       let sessionManager = SessionManager(delegate:SessionDelegate(), serverTrustPolicyManager:MyServerTrustPolicyManager(policies: [:]))
    
    var currentTotalBalance: Decimal = 0
    
    //MARK:- didLoad:
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }
    
    //MARK:- IBActions:
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Выход", message: "Вы уверенны что хотите выйти?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Да", style: .default) { (UIAlertAction) in
            currentUser = User()
            token = ""
            self.gotoAnotherView(identifier: "LoginViewController")
        }
        let noAction = UIAlertAction(title: "Нет", style: .cancel) { (UIAlertAction) in
            
        }
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        
        usernameLabel.text = currentUser.username
        emailLabel.text = currentUser.email
        
        let headers = ["Authorization": "Bearer " + token]
        let parameters: [String: Any] = [
            "UserId": currentUser.id
            ]
        let url = URL + "user/getTotalBalance"
        
        self.sessionManager.request(url, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: headers).responseJSON {
        response in
            if let status = response.response?.statusCode {
                if status == 200 {
                    print( "We got the totlaAmount!!!")
                    let balanceJSON : JSON = JSON(response.result.value!)
                    self.currentTotalBalance = Decimal(string: balanceJSON.stringValue)!
                    self.totalBalanceLabel.text = "\(self.currentTotalBalance) рублей"
                    print(balanceJSON)
                }
                else {
                    print("SERVER ERROR")
                    print("Ошибка в получении баланса")
                    print(status)
                }
            }
        }
    }
}
