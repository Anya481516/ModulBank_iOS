//
//  HistoryItem.swift
//  ModulBankApp
//
//  Created by Анна Мельхова on 30.05.2020.
//  Copyright © 2020 Anna Melkhova. All rights reserved.
//

import Foundation

class HistoryItem {
    init(){
        
    }
    init(id: String, date: String, time: String, userId: String, accountNumber: String, name: String, destination: String, sum: Int64){
        self.id = id
        self.date = date
        self.time = time
        self.userId = userId
        self.accountNumber = accountNumber
        self.name = name
        self.destination = destination
        self.sum = sum
    }
    
    var id = String()
    var date = String()
    var time = String()
    var userId = String()
    var accountNumber = String()
    var name = String()
    var destination = String()
    var sum = Int64()
}
