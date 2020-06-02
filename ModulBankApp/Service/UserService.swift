//
//  UserService.swift
//  ModulBankApp
//
//  Created by Анна Мельхова on 28.05.2020.
//  Copyright © 2020 Anna Melkhova. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

//fileprivate extension UserService {
//    enum Routes {
//        case login
//        var path: String {
//            switch self {
//            case .login:
//                return "user/login"
//            case .signup:
//                <#code#>
//            case .getUser:
//                <#code#>
//            }
//        },
//        case signup
//        var path: String {
//            switch self {
//            case .signup:
//                return "user/signup"
//            }
//        },
//        case getUser
//        var path: String {
//            switch self {
//            case .getUser:
//                return "user/getUser"
//            }
//        }
//    }
//}

class UserService {
    
    init(){
        
    }
    
    let URL = "https://192.168.1.16:44334/"
    
    open class MyServerTrustPolicyManager: ServerTrustPolicyManager {
        open override func serverTrustPolicy(forHost host: String) -> ServerTrustPolicy? {
            return ServerTrustPolicy.disableEvaluation
        }
    }
    let sessionManager = SessionManager(delegate:SessionDelegate(), serverTrustPolicyManager:MyServerTrustPolicyManager(policies: [:]))
    
    func signUp(email: String, username: String, password: String, success: @escaping () -> Void, failure: @escaping () -> Void) {
        let parameters: [String: Any] = [
            "Email": email,
            "Username": username,
            "Password": password
            ]
        let url = URL + "user/signup"
        sessionManager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{
            response in
            //if response.result.isSuccess{
                if let status = response.response?.statusCode {
                    if status == 200{
                        print("Новый пользователь был успешно зарегистрирован!" )
                        //print(value)
                        success()
                    }
                    else{
                        failure()
                        print(status)
                    }
                }
        }
    }
    
    func login(email: String, password: String,  success: @escaping () -> Void, failure: @escaping () -> Void) {
        let parameters: [String: Any] = [
            "Email": email,
            "Password": password
            ]
        let url = URL +  "user/login"
        sessionManager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{
            response in
            if response.result.isSuccess{
                // return token
                if let status = response.response?.statusCode {
                    if status == 200 {
                        token = JSON(response.result.value!)["token"].stringValue
                        
                        print("Вход успешно выполнен!")
                        print(response.result.description)
                        print(token)
                        
                        // getting the user
                        self.getByEmail(email: email, success: {
                            success()
                        }) {
                            failure()
                        }

                    }
                }
            }
            else{
                print("Ошибка во входе: \(response.result.error)")
                print(email, password, url)
            }
            
        }
        
    }
    
    func getByEmail(email: String, success: @escaping () -> Void, failure: @escaping () -> Void) {
        let headers = ["Authorization": "Bearer " + token]
        let parameters: [String: Any] = [
            "Email": email
        ]
        let url = URL + "user/getByEmail"
        
        self.sessionManager.request(url, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: headers).responseJSON{
            response in
            if response.result.isSuccess{
                if let status = response.response?.statusCode {
                    if status == 200 {
                        print( "We got the user!!!")
                        let userJSON : JSON = JSON(response.result.value!)
                        currentUser.id = userJSON["id"].string!
                        currentUser.email = userJSON["email"].string!
                        currentUser.passwordHash = userJSON["passwordHash"].string!
                        currentUser.passwordSalt = userJSON["salt"].string!
                        currentUser.username = userJSON["username"].string!
                        print(userJSON)
                        print(currentUser.id)
                        success()
                    }
                    else {
                        failure()
                    }
                }
            }
            else{
                failure()
                print("Ошибка в получении пользователя: \(response.result.error)")
            }
        }
    }
    
    func getAccounts(uid: String, success: @escaping () -> Void, failure: @escaping () -> Void){
        currentUserAccounts.removeAll()
        
        let headers = ["Authorization": "Bearer " + token]
        let parameters: [String: Any] = [
            "UserId": uid
        ]
    
        let url = URL + "user/getAccounts"
        
        self.sessionManager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON{
            response in
                if let status = response.response?.statusCode {
                    if status == 200{
                        let accountsJSON : JSON = JSON(response.result.value!)
                        print("счетазагружены")
                        var accNumber: Int64 = 123
                        if accountsJSON.count > 0 {
                            for n in 0...accountsJSON.count-1 {
                                accNumber = (accountsJSON[n]["accNumber"].int64!)
                                let accBalance = (accountsJSON[n]["balance"].int64!)
                                let accId = accountsJSON[n]["id"].string!
                                let uId = accountsJSON[n]["userId"].string!
                                let acc = Account(id: accId, userId: uId, number: accNumber, balance: accBalance)
                                currentUserAccounts.append(acc)
                            }
                        }
                        success()
                    }
                    else {
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
    
    func getHistory(uid: String, success: @escaping (_ history: [HistoryItem]) -> Void, failure: @escaping () -> Void){
        var history = [HistoryItem]()
        
        let headers = ["Authorization": "Bearer " + token]
        let parameters = [
                   "UserId": currentUser.id
                   ]
        let url = URL + "user/getHistory"
        
        self.sessionManager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON{
            response in
                if let status = response.response?.statusCode {
                    if status == 200{
                        let historyJSON : JSON = JSON(response.result.value!)
                        print("история загружена!")
                        if historyJSON.count > 0 {
                            for n in 0...historyJSON.count-1 {
                                let id = (historyJSON[n]["id"].string!)
                                let date = (historyJSON[n]["date"].string!)
                                let time = (historyJSON[n]["time"].string!)
                                let userId = (historyJSON[n]["userId"].string!)
                                let accountNumber = (historyJSON[n]["accNumber"].string!)
                                let name = (historyJSON[n]["name"].string!)
                                let destination = (historyJSON[n]["destination"].string != nil ? historyJSON[n]["destination"].string! : "")
                                let sum = (historyJSON[n]["sum"].int64!)
                                let historyItem = HistoryItem(id: id, date: date, time: time, userId: userId, accountNumber: accountNumber, name: name, destination: destination, sum:  sum)
                                history.append(historyItem)
                            }
                        }
                        success(history)
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
    
    func getHistoryWithDates(uid: String, date1: String, date2: String, success: @escaping (_ history: [HistoryItem]) -> Void, failure: @escaping () -> Void){
        var history = [HistoryItem]()
        
        let headers = ["Authorization": "Bearer " + token]
        let parameters = [ "id": currentUser.id,
                       "Date1": date1,
                        "Date2": date2
                    ]
        let url = URL + "user/getHistoryWithDate"
        
        self.sessionManager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON{
            response in
                if let status = response.response?.statusCode {
                    if status == 200{
                        let historyJSON : JSON = JSON(response.result.value!)
                        print("история загружена!")
                        if historyJSON.count > 0 {
                            for n in 0...historyJSON.count-1 {
                                let id = (historyJSON[n]["id"].string!)
                                let date = (historyJSON[n]["date"].string!)
                                let time = (historyJSON[n]["time"].string!)
                                let userId = (historyJSON[n]["userId"].string!)
                                let accountNumber = (historyJSON[n]["accNumber"].string!)
                                let name = (historyJSON[n]["name"].string!)
                                let destination = (historyJSON[n]["destination"].string != nil ? historyJSON[n]["destination"].string! : "")
                                let sum = (historyJSON[n]["sum"].int64!)
                                let historyItem = HistoryItem(id: id, date: date, time: time, userId: userId, accountNumber: accountNumber, name: name, destination: destination, sum:  sum)
                                history.append(historyItem)
                            }
                        }
                        success(history)
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
    
    func getSamples(uid: String, success: @escaping (_ samples: [SampleItem]) -> Void, failure: @escaping () -> Void){
        var samples = [SampleItem]()
        let headers = ["Authorization": "Bearer " + token]
        let parameters: [String: Any] = [
            "UserId": currentUser.id
            ]
        let url2 = URL + "user/getSamples"
        self.sessionManager.request(url2, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON{
            response in
                if let status = response.response?.statusCode {
                    if status == 200{
                        let samplesJSON : JSON = JSON(response.result.value!)
                        print("Шаблоны загружены!")
                        for n in 0...samplesJSON.count-1 {
                            let id = (samplesJSON[n]["id"].string!)
                            let userId = (samplesJSON[n]["userId"].string!)
                            let name = (samplesJSON[n]["name"].string!)
                            let email = (samplesJSON[n]["receivingEmail"].string!)
                            let sum = (samplesJSON[n]["sum"].int64!)
                            let sampleItem = SampleItem(id: id, userId: userId, name: name, email: email, sum:  sum)
                            samples.append(sampleItem)
                        }
                        //print(historyJSON)
                        success(samples)
                    }
                    else {
                        print(status)
                       failure()
                    }
                }
                //}
                else {
                print(response.error)
                print(currentUser.id)
            }
        }
    }
    
    func delete(uid: String, success: @escaping () -> Void, failure: @escaping () -> Void){
        let headers = ["Authorization": "Bearer " + token]
        let parameters: [String: Any] = [
            "UserId": uid
            ]
        let url = URL + "user/delete"
        
        self.sessionManager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON{
            response in
                if let status = response.response?.statusCode {
                    if status == 200{
                        print("Ваш аккаунт был успешно удален")
                        success()
                    }
                    else {
                        print(status)
                        failure()
                    }
                }
                else {
                print(response.error)
                print(currentUser.id)
            }
        }
    }
    
    // to be continued
    func getAllInfo(uid: UUID) -> User{
        return User()
    }
    
    func accountsNumber(uid: UUID) -> Int{
        return 1
    }
    
    func totalBalance(uid: UUID) -> Int32{
        return 10000
    }
}
