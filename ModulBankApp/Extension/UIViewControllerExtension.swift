//
//  UIViewControllerExtension.swift
//  ModulBankApp
//
//  Created by Анна Мельхова on 31.05.2020.
//  Copyright © 2020 Anna Melkhova. All rights reserved.
//

import UIKit
import Alamofire

extension UIViewController {
    // alert
    func showAlert(alertTitle : String, alertMessage : String, actionTitle : String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default) { (UIAlertAction) in
            self.view.layoutIfNeeded()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func gotoAnotherView(identifier: String, sender: UIViewController){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
               let singupVC = storyboard.instantiateViewController(identifier: identifier)
        singupVC.modalPresentationStyle = .fullScreen
        sender.dismiss(animated: true) {
            sender.present(singupVC, animated: true, completion: nil)
        }
    }
}
