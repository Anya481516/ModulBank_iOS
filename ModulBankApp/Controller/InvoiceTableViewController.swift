//
//  InvoiceTableViewController.swift
//  ModulBankApp
//
//  Created by Анна Мельхова on 23.05.2020.
//  Copyright © 2020 Anna Melkhova. All rights reserved.
//

import UIKit

class InvoiceTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, HistoryDelegate {
    
    //MARK:- PROPERTIES:
    var refreshControl = UIRefreshControl()
    var history = [HistoryItem]()
    let userService = UserService()
    
    //MARK:- IBOutlets:
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- didLoad:
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            cell.emailLabel.text = "\(historyItem.accNumber)"
        }
        else {
            cell.emailLabel.text = "С \(historyItem.accNumber) \nНа \(history[indexPath.row].destination)"
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
        
        userService.getHistory(uid: currentUserInfo.id, success: { (newHistory) in
            self.history = newHistory
            self.tableView.reloadData()
        }) {
            self.showAlert(alertTitle: "Упс!", alertMessage: "Возникла ошибка при загрузке истории", actionTitle: "Ок")
            }
    }
    
    func reloadTableData(date1: String, date2: String){
       history.removeAll()
        userService.getHistoryWithDates(uid: currentUserInfo.id, date1: date1, date2: date2, success: { (newHistory) in
           self.history = newHistory
           self.tableView.reloadData()
       }) {
           self.showAlert(alertTitle: "Упс!", alertMessage: "Возникла ошибка при загрузке истории c фильтрами", actionTitle: "Ок")
       }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromHistoryToChoosePeriod", let destinationVC = segue.destination as? DateChooseViewController {
            destinationVC.delegate = self
        }
    }
}

