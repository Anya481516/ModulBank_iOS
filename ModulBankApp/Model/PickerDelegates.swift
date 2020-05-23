//
//  PickerDelegates.swift
//  ModulBankApp
//
//  Created by Анна Мельхова on 23.05.2020.
//  Copyright © 2020 Anna Melkhova. All rights reserved.
//

import Foundation
import UIKit

//class AccountPickerDelegate: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
//
//    var accounts = [Int64]()
//
//    init(accounts: [Int64]) {
//        super.init()
//        self.accounts = accounts
//    }
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return accounts.count
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> Int64? {
//        return accounts[row]
//    }
//}
//
//class OperationPickerDelegate: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
//    let operations = ["Пополнить", "Перевод", "Платеж", "Выписка", "Открыть новый счет", "Закрыть счет"]
//
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return operations.count
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return operations[row]
//    }
//}
