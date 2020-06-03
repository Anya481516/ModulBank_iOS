//
//  Account.swift
//  ModulBankApp
//
//  Created by Анна Мельхова on 22.05.2020.
//  Copyright © 2020 Anna Melkhova. All rights reserved.
//

import Foundation

struct Account : Decodable {
    var id = String()
    var userId = String()
    var accNumber = Int64()
    var balance = Int64()
}
