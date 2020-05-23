//
//  User.swift
//  ModulBankApp
//
//  Created by Анна Мельхова on 22.05.2020.
//  Copyright © 2020 Anna Melkhova. All rights reserved.
//

import Foundation

class User {
    
    init() {
        
    }
    
    init(username: String, email: String, password: String){
        self.username = username
        self.email = email
        self.password = password
    }
    
    init (email: String, password: String){
        self.email = email
        self.password = password
    }
    
    var id = guid_t()
    var username = String()
    var email = String()
    var passwordHash = String()
    var passwordSalt = String()
    private var password = String()
}
