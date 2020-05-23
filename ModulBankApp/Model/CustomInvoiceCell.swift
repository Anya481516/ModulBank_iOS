//
//  CustomInvoiceCell.swift
//  ModulBankApp
//
//  Created by Анна Мельхова on 23.05.2020.
//  Copyright © 2020 Anna Melkhova. All rights reserved.
//

import UIKit

class CustomInvoiceCell: UITableViewCell {


    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var operationLabel: UILabel!
    @IBOutlet weak var receiverLabel: UILabel!
    @IBOutlet weak var sumLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code goes here
        
    }
}
