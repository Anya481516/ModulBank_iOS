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
    
    let userService = UserService()
    
    init() {
        
    }
    
    let URL = "https://192.168.1.16:44334/"
    
    open class MyServerTrustPolicyManager: ServerTrustPolicyManager {
        open override func serverTrustPolicy(forHost host: String) -> ServerTrustPolicy? {
            return ServerTrustPolicy.disableEvaluation
        }
    }
    let sessionManager = SessionManager(delegate:SessionDelegate(), serverTrustPolicyManager:MyServerTrustPolicyManager(policies: [:]))
    
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
    
    func deposit(uid:String, accId: String, sum: Int64, success: @escaping () -> Void, failure: @escaping () -> Void){
       let headers = ["Authorization": "Bearer " + token]
        let parameters: [String: Any] = [
            "AccId": chosenAcc.id,
            "Sum": sum
            ]
        let url = URL + "account/deposit"
        
        sessionManager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON{
            response in
                if let status = response.response?.statusCode {
                    if status == 200{
                        print("счет пополнен!")
                        chosenAcc.balance = chosenAcc.balance + sum
                        currentUserAccounts = [Account]()
                        // счета снова загрузить
                        self.userService.getAccounts(uid: uid, success: {
                            success()
                        }) {
                            failure()
                        }
                    }
                    else {
                        failure()
                        print(status)
                    }
                }
                else {
                print(response.error)
                failure()
            }
        }
    }
    
    func transfer(sendingAccId: String, receivingAccNumber: Int64, sum: Int64, success: @escaping () -> Void, failure: @escaping () -> Void){
        let headers = ["Authorization": "Bearer " + token]
        let parameters: [String: Any] = [
            "SendingAccId": sendingAccId,
            "ReceivingAccNumber": receivingAccNumber,
            "Sum": sum
        ]
        let url = URL + "account/transfer_to_another_account"
        
        self.sessionManager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON{
        response in
            if let status = response.response?.statusCode {
                if status == 200{
                    print("перевод выполнен!")
                    chosenAcc.balance = sum
                    // get users again
                    self.userService.getAccounts(uid: currentUser.id, success: {
                        success()
                    }) {
                        failure()
                    }
                }
                else {
                    print(response.error)
                    failure()
                }
            }
            else {
                print(response.error)
                failure()
            }
        }
    }
}
