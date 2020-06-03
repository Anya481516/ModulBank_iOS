//
//  SampleItem.swift
//  ModulBankApp
//
//  Created by Анна Мельхова on 31.05.2020.
//  Copyright © 2020 Anna Melkhova. All rights reserved.
//

import Foundation

struct SampleItem : Decodable {
    var id = String()
    var userId = String()
    var name = String()
    var receivingEmail = String()
    var sum = Int64()
}
