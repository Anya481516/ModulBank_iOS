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
// delete after
        username = ""
        email = ""
        id = String()
        passwordHash = ""
        passwordSalt = ""
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
    
    init(user: User){
        self.username = user.username
        self.email = user.email
        self.passwordHash = user.passwordHash
        self.passwordSalt = user.passwordSalt
        self.id = user.id
    }
    
    var id = String()
    var username = String()
    var email = String()
    var passwordHash = String()
    var passwordSalt = String()
    private var password = String()
}
