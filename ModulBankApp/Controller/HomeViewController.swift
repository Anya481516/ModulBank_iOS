//
//  HomeViewController.swift
//  ModulBankApp
//
//  Created by Анна Мельхова on 22.05.2020.
//  Copyright © 2020 Anna Melkhova. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    //MARK:- PROPERTIES:
    let userService = UserService()
    var currentTotalBalance: Decimal = 0
    
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
        let alert = UIAlertController(title: "Выход", message: "Вы уверенны что хотите выйти?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Да", style: .default) { (UIAlertAction) in
            currentUserInfo = UserInfo()
            token = ""
            self.gotoAnotherView(identifier: "LoginViewController")
        }
        let noAction = UIAlertAction(title: "Нет", style: .cancel) { (UIAlertAction) in
            
        }
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated: true, completion: nil)
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
    
    override func viewWillAppear(_ animated: Bool) {
        usernameLabel.text = currentUserInfo.username
        emailLabel.text = currentUserInfo.email
        
        userService.getTotalBalance(uid: currentUserInfo.id, success: { (balance) in
            self.currentTotalBalance = balance
            self.totalBalanceLabel.text = "\(self.currentTotalBalance) рублей"
        }) {
            self.totalBalanceLabel.text = "Ошибка в загрузке баланса"
        }
    }
}
