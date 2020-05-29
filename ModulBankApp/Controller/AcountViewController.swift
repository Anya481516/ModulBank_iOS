//
//  AcountViewController.swift
//  ModulBankApp
//
//  Created by Анна Мельхова on 22.05.2020.
//  Copyright © 2020 Anna Melkhova. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    open class MyServerTrustPolicyManager: ServerTrustPolicyManager {
        open override func serverTrustPolicy(forHost host: String) -> ServerTrustPolicy? {
            return ServerTrustPolicy.disableEvaluation
        }
    }
    
    let sessionManager = SessionManager(delegate:SessionDelegate(), serverTrustPolicyManager:MyServerTrustPolicyManager(policies: [:]))
    
    //MARK:- IBOutlets:
    @IBOutlet weak var tableView: UITableView!
    var refreshControl = UIRefreshControl()
    
    //MARK:- didLoad:
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "AccountCell", bundle: nil), forCellReuseIdentifier: "customAccountCell")
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        // Do any additional setup after loading the view.
        // TODO: define the accounts

    }
    
    //MARK:- IBActions:

    
    //MARK:- METHODS:
    
    @objc func refresh(_ sender: AnyObject) {
        let headers = ["Authorization": "Bearer " + token]
        let parameters: [String: Any] = [
            "UserId": currentUser.id
            ]
        let url = URL + "user/getTotalBalance"
       let url2 = URL + "user/getAccounts"
       
       self.sessionManager.request(url2, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON{
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
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUserAccounts.count
       }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customAccountCell", for: indexPath) as! CustomAccountCell
        cell.balanceLabel.text = "\(currentUserAccounts[indexPath.row].balance)"
        cell.titleLabel.text = String(currentUserAccounts[indexPath.row].number)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenAcc = currentUserAccounts[indexPath.row]
        self.performSegue(withIdentifier: "fromAccountToDetails", sender: self)
    }
    
    func configureTableView() {
           tableView.rowHeight = 60
           tableView.estimatedRowHeight = 80
       }
    
    override func viewWillAppear(_ animated: Bool) {
        
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
