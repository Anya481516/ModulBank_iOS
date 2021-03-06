//
//  InvoiceViewController.swift
//  ModulBankApp
//
//  Created by Анна Мельхова on 23.05.2020.
//  Copyright © 2020 Anna Melkhova. All rights reserved.
//

import UIKit

protocol HistoryDelegate {
    func reloadTableData(date1: String, date2: String)
}

class DateChooseViewController: UIViewController {

    //MARK:- PROPERTIES:
    var delegate : HistoryDelegate?
    
    //MARK:- IBOutlets:
    @IBOutlet weak var date1Picker: UIDatePicker!
    @IBOutlet weak var date2Picker: UIDatePicker!
    
    //MARK:- didLoad:
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK:- IBActions:
    @IBAction func showInvoiceButtonPressed(_ sender: Any) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date1 = dateFormatter.string(from: date1Picker.date)
        let date2 = dateFormatter.string(from: date2Picker.date)
        
        delegate?.reloadTableData(date1: date1, date2: date2)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- METHODS:

}
