//
//  UIViewControllerExtension.swift
//  ModulBankApp
//
//  Created by Анна Мельхова on 31.05.2020.
//  Copyright © 2020 Anna Melkhova. All rights reserved.
//

import UIKit

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
}
