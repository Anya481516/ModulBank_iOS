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

class InvoiceTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, HistoryDelegate {
    
    //MARK:- IBOutlets:
    @IBOutlet weak var tableView: UITableView!
    var refreshControl = UIRefreshControl()
    var history = [HistoryItem]()
    var headers = ["Authorization": "Bearer " + token]
    //var defaultDate: Bool!
    var parameters: [String: Any]!
    var url2: String!
    
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
        let historyItem = history[indexPath.row]
        cell.dateLabel.text = "\(historyItem.date) \(historyItem.time)"
        if history[indexPath.row].name == "Пополнение" {
            cell.emailLabel.text = "\(historyItem.accountNumber)"
        }
        else {
            cell.emailLabel.text = "С \(historyItem.accountNumber) \nНа \(history[indexPath.row].destination)"
        }
        cell.sumLabel.text = "\(historyItem.sum) Р"
        cell.titleLabel.text = "\(historyItem.name)"
        return cell
    }
    
    func configureTableView() {
        tableView.rowHeight = 75
        tableView.estimatedRowHeight = 120
    }
    
    override func viewWillAppear(_ animated: Bool) {
        history.removeAll()
        
      
            parameters = [
                       "UserId": currentUser.id
                       ]
            
            
            url2 = URL + "user/getHistory"
        
    
        self.sessionManager.request(url2, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON{
            response in
                if let status = response.response?.statusCode {
                    if status == 200{
                        let historyJSON : JSON = JSON(response.result.value!)
                        print("история загружена!")
                        if historyJSON.count > 0 {
                            for n in 0...historyJSON.count-1 {
                                let id = (historyJSON[n]["id"].string!)
                                let date = (historyJSON[n]["date"].string!)
                                let time = (historyJSON[n]["time"].string!)
                                let userId = (historyJSON[n]["userId"].string!)
                                let accountNumber = (historyJSON[n]["accNumber"].string!)
                                let name = (historyJSON[n]["name"].string!)
                                let destination = (historyJSON[n]["destination"].string != nil ? historyJSON[n]["destination"].string! : "")
                                let sum = (historyJSON[n]["sum"].int64!)
                                let historyItem = HistoryItem(id: id, date: date, time: time, userId: userId, accountNumber: accountNumber, name: name, destination: destination, sum:  sum)
                                self.history.append(historyItem)
                            }
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
    
    func reloadTableData(date1: String, date2: String){
        
        
        parameters = [ "id": currentUser.id,
                       "Date1": date1,
                        "Date2": date2
                    ]
        url2 = URL + "user/getHistoryWithDate"
       history.removeAll()
       
       sessionManager.request(url2, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON{
           response in
               if let status = response.response?.statusCode {
                   if status == 200{
                       let historyJSON : JSON = JSON(response.result.value!)
                       print("история c фильтрами  загружена!")
                       for n in 0...historyJSON.count-1 {
                           let id = (historyJSON[n]["id"].string!)
                           let date = (historyJSON[n]["date"].string!)
                           let time = (historyJSON[n]["time"].string!)
                           let userId = (historyJSON[n]["userId"].string!)
                           let accountNumber = (historyJSON[n]["accNumber"].string!)
                           let name = (historyJSON[n]["name"].string!)
                           let destination = (historyJSON[n]["destination"].string != nil ? historyJSON[n]["destination"].string! : "")
                           let sum = (historyJSON[n]["sum"].int64!)
                           let historyItem = HistoryItem(id: id, date: date, time: time, userId: userId, accountNumber: accountNumber, name: name, destination: destination, sum:  sum)
                           self.history.append(historyItem)
                       }
                       self.tableView.reloadData()
                   }
                   else {
                       self.showAlert(alertTitle: "Упс!", alertMessage: "Возникла ошибка при загрузке истории с фильтрами", actionTitle: "Ок")
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
              if segue.identifier == "fromHistoryToChoosePeriod", let destinationVC = segue.destination as? DateChooseViewController {
                  destinationVC.delegate = self
              }
          }
}

