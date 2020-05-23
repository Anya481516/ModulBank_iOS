//
//  SampleViewController.swift
//  ModulBankApp
//
//  Created by Анна Мельхова on 23.05.2020.
//  Copyright © 2020 Anna Melkhova. All rights reserved.
//

import UIKit

class SampleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    //MARK:- IBOutlets:
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- didLoad:
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "Sample2Cell", bundle: nil), forCellReuseIdentifier: "customSample2Cell")
        self.configureTableView()
    }
    
    //MARK:- IBActions:
    @IBAction func createButtonPressed(_ sender: Any) {
    }
    
    //MARK:- METHODS:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customSample2Cell", for: indexPath) as! CustomSample2Cell
        return cell
    }
    
    func configureTableView() {
        tableView.rowHeight = 75
        tableView.estimatedRowHeight = 120
    }

}

