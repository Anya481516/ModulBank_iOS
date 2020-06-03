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

fileprivate extension UserService {
    enum Routes {
        case login, signup, getUser, getByEmail, getAccounts, getHistory, getHistoryWithDate, getSamples, delete, getTotalBalance
        var path: String {
            switch self {
            case .login:
                return "user/login"
            case .signup:
                return "user/signup"
            case .getUser:
                return "user/getUser"
            case .getByEmail:
                return "user/getByEmail"
            case .getAccounts:
                return "user/getAccounts"
            case .getHistory:
                return "user/getHistory"
            case .getHistoryWithDate:
                return "user/getHistoryWithDate"
            case .getSamples:
                return "user/getSamples"
            case .delete:
                return "user/delete"
            case .getTotalBalance:
                return "user/getTotalBalance"
            }
        }
    }
}

class UserService {
    
    let URL = "https://192.168.0.100:44334/"
    
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
        let url = URL + Routes.signup.path
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
    
    func login(email: String, password: String,  success: @escaping (UserInfo?) -> Void, failure: @escaping () -> Void) {
        let parameters: [String: Any] = [
            "Email": email,
            "Password": password
            ]
        let url = URL +  Routes.login.path
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
                    
                        self.getByEmail(email: email, success: { (userInfo) in
                            let user = userInfo
                            success(user)
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
    
    func getByEmail(email: String, success: @escaping (UserInfo?) -> Void, failure: @escaping () -> Void) {
        let headers = ["Authorization": "Bearer " + token]
        let parameters: [String: Any] = [
            "Email": email
        ]
        let url = URL + Routes.getByEmail.path
        
        self.sessionManager.request(url, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: headers).responseJSON{
            response in
            guard let data = response.data else { return }
            do {
                print(data.description)
                let decoder = JSONDecoder()
                let userInfo = try decoder.decode(UserInfo.self, from: data)
                success(userInfo)
            } catch let error {
                print("Ошибка в получении пользователя: \(error)")
                failure()
            }
        }
    }
    
    func getAccounts(uid: String, success: @escaping () -> Void, failure: @escaping () -> Void){
        currentUserAccounts.removeAll()
        
        let headers = ["Authorization": "Bearer " + token]
        let parameters: [String: Any] = [
            "UserId": uid
        ]
    
        let url = URL + Routes.getAccounts.path
        
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
        let url = URL + Routes.getHistory.path
        
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
        let url = URL + Routes.getHistoryWithDate.path
        
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
        let url2 = URL + Routes.getSamples.path
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
        let url = URL + Routes.delete.path
        
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
    
    func getTotalBalance(uid: String, success: @escaping (_ totlaBalance: Decimal) -> Void, failure: @escaping () -> Void){
        let headers = ["Authorization": "Bearer " + token]
        let parameters: [String: Any] = [
            "UserId": uid
            ]
        let url = URL + Routes.getTotalBalance.path
        
        self.sessionManager.request(url, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: headers).responseJSON {
        response in
            if let status = response.response?.statusCode {
                if status == 200 {
                    print( "We got the totlaAmount!!!")
                    let balanceJSON : JSON = JSON(response.result.value!)
                    let balance = Decimal(string: balanceJSON.stringValue)!
                    print(balanceJSON)
                    success(balance)
                }
                else {
                    print("SERVER ERROR")
                    print("Ошибка в получении баланса")
                    print(status)
                    failure()
                }
            }
        }
    }
}
