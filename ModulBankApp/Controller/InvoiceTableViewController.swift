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

    }
    
    //MARK:- IBActions:
    
    //MARK:- METHODS:
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 12
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customInvoiceCell", for: indexPath) as! CustomInvoiceCell
        
        return cell
    }
    
    func configureTableView() {
        tableView.rowHeight = 75
        tableView.estimatedRowHeight = 120
    }

}

