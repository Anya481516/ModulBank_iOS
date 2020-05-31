//
//  InvoiceTableViewController.swift
//  ModulBankApp
//
//  Created by Анна Мельхова on 23.05.2020.
//  Copyright © 2020 Anna Melkhova. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class InvoiceTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK:- IBOutlets:
    @IBOutlet weak var tableView: UITableView!
    var refreshControl = UIRefreshControl()
    var history = [HistoryItem]()
    
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
        
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "InvoiceCell", bundle: nil), forCellReuseIdentifier: "customInvoiceCell")
        self.configureTableView()
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)

    }
    
    //MARK:- IBActions:
    
    //MARK:- METHODS:
    @objc func refresh(_ sender: AnyObject) {
          tableView.reloadData()
          refreshControl.endRefreshing()
      }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return history.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customInvoiceCell", for: indexPath) as! CustomInvoiceCell
        cell.dateLabel.text = "\(history[indexPath.row].date) \(history[indexPath.row].time)"
        cell.emailLabel.text = "\(history[indexPath.row].destination)"
        cell.titleLabel.text = "\(history[indexPath.row].name)"
        return cell
    }
    
    func configureTableView() {
        tableView.rowHeight = 75
        tableView.estimatedRowHeight = 120
    }
    
    override func viewWillAppear(_ animated: Bool) {
        history.removeAll()
        
        let headers = ["Authorization": "Bearer " + token]
               let parameters: [String: Any] = [
                   "UserId": currentUser.id
                   ]
        
        
        let url2 = URL + "user/getHistory"
        
        self.sessionManager.request(url2, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON{
            response in
                if let status = response.response?.statusCode {
                    if status == 200{
                        let historyJSON : JSON = JSON(response.result.value!)
                        print("история загружена!")
                        for n in 0...historyJSON.count-1 {
                            let id = (historyJSON[n]["id"].string!)
                            let date = (historyJSON[n]["date"].string!)
                            let time = (historyJSON[n]["time"].string!)
                            let userId = (historyJSON[n]["userId"].string!)
                            //let accountId = (historyJSON[n]["accId"].int64!)
                            let name = (historyJSON[n]["name"].string!)
                            let destination = (historyJSON[n]["destination"].string != nil ? historyJSON[n]["destination"].string! : "")
                            let sum = (historyJSON[n]["sum"].int64!)
                            let historyItem = HistoryItem(id: id, date: date, time: time, userId: userId, name: name, destination: destination, sum:  sum)
                            self.history.append(historyItem)
                        }
                        self.tableView.reloadData()
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
    }

}

