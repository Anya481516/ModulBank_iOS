//
//  SampleViewController.swift
//  ModulBankApp
//
//  Created by Анна Мельхова on 23.05.2020.
//  Copyright © 2020 Anna Melkhova. All rights reserved.
//

import UIKit

protocol SampleDelegate {
    func fillInfo(name: String, email: String, sum: Int64)
}

class SampleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK:- PROPERTIES:
    var delegate : SampleDelegate?
    var samples = [SampleItem]()
    let userService = UserService()
    var refreshControl = UIRefreshControl()
    
    //MARK:- IBOutlets:
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- didLoad:
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ExampleCell", bundle: nil), forCellReuseIdentifier: "customExampleCell")
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
        return samples.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customExampleCell", for: indexPath) as! CustomExampleCell
        cell.sumLabel.text = "\(samples[indexPath.row].sum) P"
        cell.titleLabel.text = "\(samples[indexPath.row].name)"
        cell.emailLabel.text = "\(samples[indexPath.row].receivingEmail)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sample = samples[indexPath.row]
        delegate?.fillInfo(name: sample.name, email: sample.name, sum: sample.sum)
        self.dismiss(animated: true, completion: nil)
    }
    
    func configureTableView() {
        tableView.rowHeight = 75
        tableView.estimatedRowHeight = 120
    }
    
    override func viewWillAppear(_ animated: Bool) {
        samples.removeAll()
        userService.getSamples(uid: currentUserInfo.id, success: { (newSamples) in
            self.samples = newSamples
            self.tableView.reloadData()
        }) {
            self.showAlert(alertTitle: "Упс!", alertMessage: "Возникла ошибка при загрузке шаблонов", actionTitle: "Ок")
        }
    }

}

