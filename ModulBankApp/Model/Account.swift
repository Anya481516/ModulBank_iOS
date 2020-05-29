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
    init(id: String, userId: String, number: Int64, balance: Int64){
        self.id = id
        self.userId = userId
        self.balance = balance
        self.number = number
    }
    
    var id = String()
    var userId = String()
    var number = Int64()
    var balance = Int64()
}
