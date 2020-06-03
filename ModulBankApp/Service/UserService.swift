//
//  UserService.swift
//  ModulBankApp
//
//  Created by Анна Мельхова on 28.05.2020.
//  Copyright © 2020 Anna Melkhova. All rights reserved.
//

import Foundation
import Alamofire

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
            if let status = response.response?.statusCode {
                if status == 200{
                    print("Новый пользователь был успешно зарегистрирован!" )
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
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                token = try decoder.decode(TokenInfo.self, from: data).token
                print(token)
                print("Вход успешно выполнен!")
                self.getByEmail(email: email, success: { (userInfo) in
                    let user = userInfo
                    success(user)
                }) {
                    failure()
                }
            } catch let error {
                print("Ошибка в авторизации: \(error)")
                failure()
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
    
    func getAccounts(uid: String, success: @escaping ([Account]) -> Void, failure: @escaping () -> Void) {
        let headers = ["Authorization": "Bearer " + token]
        let parameters: [String: Any] = [
            "UserId": uid
        ]
    
        let url = URL + Routes.getAccounts.path
        
        self.sessionManager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON{
            response in
            guard let data = response.data else { return }
            do {
                print("счетазагружены")
                let decoder = JSONDecoder()
                let accounts = try decoder.decode([Account].self, from: data)
                success(accounts)
            } catch let error {
                print("Ошибка в получении счетов: \(error)")
                failure()
            }
        }
    }
    
    func getHistory(uid: String, success: @escaping ([HistoryItem]) -> Void, failure: @escaping () -> Void){
        let headers = ["Authorization": "Bearer " + token]
        let parameters = [
                   "UserId": uid
                   ]
        let url = URL + Routes.getHistory.path
        
        self.sessionManager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON{
            response in
            guard let data = response.data else { return }
            do {
                print("история загружена")
                let decoder = JSONDecoder()
                let history = try decoder.decode([HistoryItem].self, from: data)
                success(history)
            } catch let error {
                print("Ошибка в получении истории: \(error)")
                failure()
            }
        }
    }
    
    func getHistoryWithDates(uid: String, date1: String, date2: String, success: @escaping (_ history: [HistoryItem]) -> Void, failure: @escaping () -> Void){
        let headers = ["Authorization": "Bearer " + token]
        let parameters = [ "id": uid,
                       "Date1": date1,
                        "Date2": date2
                    ]
        let url = URL + Routes.getHistoryWithDate.path
        
        self.sessionManager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON{
            response in
            guard let data = response.data else { return }
            do {
                print("история с фильтрами загружена")
                let decoder = JSONDecoder()
                let history = try decoder.decode([HistoryItem].self, from: data)
                success(history)
            } catch let error {
                print("Ошибка в получении истории с фильтрами: \(error)")
                failure()
            }
        }
    }
    
    func getSamples(uid: String, success: @escaping (_ samples: [SampleItem]) -> Void, failure: @escaping () -> Void){
        let headers = ["Authorization": "Bearer " + token]
        let parameters: [String: Any] = [
            "UserId": uid
            ]
        let url2 = URL + Routes.getSamples.path
        self.sessionManager.request(url2, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON{
            response in
            
            guard let data = response.data else { return }
            do {
                print("Шаблоны загружены!")
                let decoder = JSONDecoder()
                let samples = try decoder.decode([SampleItem].self, from: data)
                success(samples)
            } catch let error {
                print("Ошибка в получении шаблонов: \(error)")
                failure()
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
                print(currentUserInfo.id)
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
            
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                print("We got the totlaAmount!!!")
                let balance = try decoder.decode(Int.self, from: data)
                success(Decimal(balance))
            } catch let error {
                print("Ошибка в получении баланса : \(error)")
                failure()
            }
        }
    }
}
