//
//  Account.swift
//  ModulBankApp
//
//  Created by Анна Мельхова on 22.05.2020.
//  Copyright © 2020 Anna Melkhova. All rights reserved.
//

import Foundation

class Account {
    
    init() {
        
    }
    
    var id = guid_t()
    var userId = guid_t()
    var number = Int64()
    var balance = Decimal()
}
