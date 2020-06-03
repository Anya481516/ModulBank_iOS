//
//  SampleItem.swift
//  ModulBankApp
//
//  Created by Анна Мельхова on 31.05.2020.
//  Copyright © 2020 Anna Melkhova. All rights reserved.
//

import Foundation

class SampleItem : Decodable {
    init(){
        
    }
    init(id: String, userId: String,name: String, email: String, sum: Int64){
        self.id = id
        self.userId = userId
        self.name = name
        self.email = email
        self.sum = sum
    }
    
    var id = String()
    var userId = String()
    var name = String()
    var email = String()
    var sum = Int64()
}
