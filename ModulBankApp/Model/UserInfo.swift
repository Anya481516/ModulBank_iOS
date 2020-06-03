//
//  UserInfo.swift
//  ModulBankApp
//
//  Created by Анна Мельхова on 03.06.2020.
//  Copyright © 2020 Anna Melkhova. All rights reserved.
//

import Foundation

struct UserInfo : Decodable {
    var id = String()
    var username = String()
    var email = String()
    var passwordHash = String()
    var salt = String()
}
