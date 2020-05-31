//
//  SampleViewController.swift
//  ModulBankApp
//
//  Created by Анна Мельхова on 23.05.2020.
//  Copyright © 2020 Anna Melkhova. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol SampleProtocol {
    func fillInfo(name: String, email: String, sum: Int64)
}

class SampleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK:- IBOutlets:
    @IBOutlet weak var tableView: UITableView!
      var refreshControl = UIRefreshControl()
    var delegate : SampleProtocol?
    
    var samples = [SampleItem]()
    
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
        cell.emailLabel.text = "\(samples[indexPath.row].email)"
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
        
        let headers = ["Authorization": "Bearer " + token]
               let parameters: [String: Any] = [
                   "UserId": currentUser.id
                   ]
        
        
        let url2 = URL + "user/getSamples"
        
        self.sessionManager.request(url2, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON{
            response in
                if let status = response.response?.statusCode {
                    if status == 200{
                        let historyJSON : JSON = JSON(response.result.value!)
                        print("Шаблоны загружены!")
                        for n in 0...historyJSON.count-1 {
                            let id = (historyJSON[n]["id"].string!)
                            let userId = (historyJSON[n]["userId"].string!)
                            let name = (historyJSON[n]["name"].string!)
                            let email = (historyJSON[n]["receivingEmail"].string!)
                            let sum = (historyJSON[n]["sum"].int64!)
                            let sampleItem = SampleItem(id: id, userId: userId, name: name, email: email, sum:  sum)
                            self.samples.append(sampleItem)
                        }
                        //print(historyJSON)
                        self.tableView.reloadData()
                    }
                    else {
                        self.showAlert(alertTitle: "Упс!", alertMessage: "Возникла ошибка при загрузке шаблонов", actionTitle: "Ок")
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

