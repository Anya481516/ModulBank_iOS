//
//  AcountViewController.swift
//  ModulBankApp
//
//  Created by Анна Мельхова on 22.05.2020.
//  Copyright © 2020 Anna Melkhova. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    
    
    //MARK:- IBOutlets:
    @IBOutlet weak var tableView: UITableView!
    
    var accounts = [Int64]()
    var balances = [Int]()
    
    //MARK:- didLoad:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accounts = [4000000000, 4000000001, 4000000002]
        balances = [1000, 43221, 43211]
        
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "AccountCell", bundle: nil), forCellReuseIdentifier: "customAccountCell")
        self.configureTableView()
        
        // Do any additional setup after loading the view.
        // TODO: define the accounts

    }
    
    //MARK:- IBActions:

    
    //MARK:- METHODS:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "customAccountCell", for: indexPath) as! CustomAccountCell
           return cell
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "fromAccountToDetails", sender: self)
    }
    
    func configureTableView() {
           tableView.rowHeight = 60
           tableView.estimatedRowHeight = 80
       }
    
    
    
}
