//
//  AccountService.swift
//  ModulBankApp
//
//  Created by Анна Мельхова on 28.05.2020.
//  Copyright © 2020 Anna Melkhova. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AccountService {
    
    init() {
        
    }
    
    func openNew(uid: UUID, balance: Decimal) -> String {
        var answer = "some error"
        let parameters: [String: Any] = [
            "UserId": uid,
            "Balance": balance
            ]
        let url = "https://localhost:44334/account/openNew"
        
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON{
            response in
            if response.result.isSuccess{
                answer = "Новый счет был успешно создан!"
            }
            else{
                answer = "Ошибка в открытии счета: \(response.result.error)"
            }
        }
        return answer
    }
    
    func get(accId: UUID) -> Account {
        var answer = "some error"
        let account = Account()
        let parameters: [String: Any] = [
            "AccId": accId
            ]
        //надо токен еще вставлять найти как (уже после того как пойму как подключиться к серверу моему)
        let url = "https://localhost:44334/account/get"
        
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON{
            response in
            if response.result.isSuccess{
                answer = "Вход успешно выполнен!"
                let userJSON : JSON = JSON(response.result.value!)
                account.id = userJSON["id"].string!
                account.number = Int64(userJSON["accNumber"].string!)!
                account.balance = (userJSON["balance"].int64!)
            }
            else{
                answer = "Ошибка в получении пользователя: \(response.result.error)"
            }
        }
        return account
    }
    
    func deposit(accId: UUID, sum: Int32) -> String{
        var answer = "some error"
        let parameters: [String: Any] = [
            "AccId": accId,
            "Sum": sum
            ]
        let url = "https://localhost:44334/account/deposit"
        
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON{
            response in
            if response.result.isSuccess{
                answer = "Ваш счет был успешно пополнен!"
            }
            else{
                answer = "Ошибка в пополнении счета: \(response.result.error)"
            }
        }
        return answer
    }
    
    func transfer(sendingAccId: UUID, receivingAccId: UUID, sum: Int32) -> String{
        var answer = "some error"
        let parameters: [String: Any] = [
            "SendingAccId":  sendingAccId,
            "ReceivingAccId":  receivingAccId,
            "sum": sum
            ]
        let url = "https://localhost:44334/account/transfer_to_another_account"
        
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON{
            response in
            if response.result.isSuccess{
                answer = "Перевод был успешно совершен!"
            }
            else{
                answer = "Ошибка в переводе: \(response.result.error)"
            }
        }
        return answer
    }

}
