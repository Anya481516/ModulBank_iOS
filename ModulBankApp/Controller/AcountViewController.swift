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
        tableView.reloadData()
        refreshControl.endRefreshing()
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
        tableView.reloadData()
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
