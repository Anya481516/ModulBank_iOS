//
//  HistoryItem.swift
//  ModulBankApp
//
//  Created by Анна Мельхова on 30.05.2020.
//  Copyright © 2020 Anna Melkhova. All rights reserved.
//

import Foundation

struct HistoryItem : Decodable {
    var id = String()
    var date = String()
    var time = String()
    var userId = String()
    var accNumber = String()
    var name = String()
    var destination = String()
    var sum = Int64()
}
