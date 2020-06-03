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

fileprivate extension AccountService {
    enum Routes {
        case openNew, deposit, transfer_to_another_account, payment, saveToSamples
        var path: String {
            switch self {
            case .openNew:
                return "account/openNew"
            case .deposit:
                return "account/deposit"
            case .transfer_to_another_account:
                return "account/transfer_to_another_account"
            case .payment:
                return "account/payment"
            case .saveToSamples:
                return "account/saveToSamples"
            }
        }
    }
}

class AccountService {
    
    let userService = UserService()
    
    let URL = "https://192.168.0.100:44334/"
    
    open class MyServerTrustPolicyManager: ServerTrustPolicyManager {
        open override func serverTrustPolicy(forHost host: String) -> ServerTrustPolicy? {
            return ServerTrustPolicy.disableEvaluation
        }
    }
    let sessionManager = SessionManager(delegate:SessionDelegate(), serverTrustPolicyManager:MyServerTrustPolicyManager(policies: [:]))
    
    func openNew(uid:String, balance: Int64, success: @escaping () -> Void, failure: @escaping () -> Void) {
        let headers = ["Authorization": "Bearer " + token]
        let parameters: [String: Any] = [
            "UserId": currentUser.id,
            "Balance": balance
            ]
        let url = URL + Routes.openNew.path
        
        self.sessionManager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON{
            response in
                if let status = response.response?.statusCode {
                    if status == 200{
                        print("Аккаунт создан")
                        currentUserAccounts = [Account]()
//                        self.userService.getAccounts(uid: uid, success: {
//                            success()
//                        }) {
//                            failure()
//                        }
                    }
                    else {
                        print(status)
                        failure()
                    }
                }
                //}
                else {
                    print(response.error)
                    failure()
            }
        }
    }
    
    func deposit(uid:String, accId: String, sum: Int64, success: @escaping () -> Void, failure: @escaping () -> Void){
       let headers = ["Authorization": "Bearer " + token]
        let parameters: [String: Any] = [
            "AccId": chosenAcc.id,
            "Sum": sum
            ]
        let url = URL + Routes.deposit.path
        
        sessionManager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON{
            response in
                if let status = response.response?.statusCode {
                    if status == 200{
                        print("счет пополнен!")
                        chosenAcc.balance = chosenAcc.balance + sum
                        currentUserAccounts = [Account]()
                        // счета снова загрузить
//                        self.userService.getAccounts(uid: uid, success: {
//                            success()
//                        }) {
//                            failure()
//                        }
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
        let url = URL + Routes.transfer_to_another_account.path
        
        self.sessionManager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON{
        response in
            if let status = response.response?.statusCode {
                if status == 200{
                    print("перевод выполнен!")
                    chosenAcc.balance = sum
                    // get users again
//                    self.userService.getAccounts(uid: currentUser.id, success: {
//                        success()
//                    }) {
//                        failure()
//                    }
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
    
    func payment(name: String, email: String, sum: Int64, success: @escaping () -> Void, failure: @escaping () -> Void){
        let headers = ["Authorization": "Bearer " + token]
        let parameters: [String: Any] = [
            "AccId": chosenAcc.id,
             "Name": name,
             "Destination": email,
             "Sum": sum
            ]
        let url = URL + Routes.payment.path
        
        self.sessionManager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON{
            response in
                if let status = response.response?.statusCode {
                    if status == 200{
                        print("платеж совершен!")
                        chosenAcc.balance = chosenAcc.balance - sum
                        currentUserAccounts = [Account]()
//                        self.userService.getAccounts(uid: currentUser.id, success: {
//                            success()
//                        }) {
//                            failure()
//                        }
                    }
                    else {
                        print(status)
                       failure()
                    }
                }
                else {
                    print(response.error)
                    failure()
                }
        }
    }
    
    func saveToSamples(name: String, email: String, sum: Int64, success: @escaping () -> Void, failure: @escaping () -> Void){
        let headers = ["Authorization": "Bearer " + token]
        let parameters: [String: Any] = [
            "AccId": chosenAcc.id,
             "Name": name,
             "Destination": email,
             "Sum": sum
            ]
        let url = URL + Routes.saveToSamples.path
        
        self.sessionManager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON{
            response in
                if let status = response.response?.statusCode {
                if status == 200{
                    success()
                    
                    }
                else {
                    print(response.error)
                    failure()
                        
                    }
            }
        }
    }
}
