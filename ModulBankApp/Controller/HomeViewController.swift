//
//  HomeViewController.swift
//  ModulBankApp
//
//  Created by Анна Мельхова on 22.05.2020.
//  Copyright © 2020 Anna Melkhova. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    //MARK:- IBOutlets:
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var totalBalanceLabel: UILabel!
    
    //MARK:- didLoad:
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- IBActions:
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        gotoAnotherView(identifier: "LoginViewController")
    }
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
    }
    
    //MARK:- METHODS:
    
    func gotoAnotherView(identifier: String){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
               let singupVC = storyboard.instantiateViewController(identifier: identifier)
        singupVC.modalPresentationStyle = .fullScreen
        self.dismiss(animated: true) {
            self.present(singupVC, animated: true, completion: nil)
        }
    }
    
}
