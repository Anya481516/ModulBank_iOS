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
    
    let baseURL: URL = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "192.168.0.100"
        components.port = 44334
        guard let url = components.url else {
            fatalError("can't create baseUrl")
        }
        return url
    }()
    
    
    
    
    open class MyServerTrustPolicyManager: ServerTrustPolicyManager {
        open override func serverTrustPolicy(forHost host: String) -> ServerTrustPolicy? {
            return ServerTrustPolicy.disableEvaluation
        }
    }
    let sessionManager = SessionManager(delegate:SessionDelegate(), serverTrustPolicyManager:MyServerTrustPolicyManager(policies: [:]))
    
    func signUp(email: String, username: String, password: String) -> String {
        var answer = "some error"
        let parameters: [String: Any] = [
            "Email": email,
            "Username": username,
            "Password": password
            ]
        //let url2 = "http://api.openweathermap.org/data/2.5/weather"
        let url = "https://192.168.0.100:44334/user/signup"
        
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON{
            response in
            if response.result.isSuccess{
                answer = "Новый пользователь был успешно зарегистрирован!"
            }
            else{
                answer = "Ошибка в регистрации: \(response.result.error)"
            }
        }
        return answer
    }
    
    func login(email: String, password: String) -> String {
        var answer = "some error"
        let loginParameters: [String: Any] = [
            "Email": email,
            "Password": password
            ]
        let url = "https://192.168.0.100:44334/user/login"
        var tokenJS = ""
        sessionManager.request(url, method: .post, parameters: loginParameters, encoding: JSONEncoding.default).responseJSON{
            response in
            if response.result.isSuccess{
                // return token
                token = JSON(response.result.value!)["token"].stringValue
                print("Вход успешно выполнен!")
                print(response.result)
                print("token from Service: \(token)")
                
            }
            else{
                print("Ошибка во входе: \(response.result.error)")
                print(email, password, url)
            }
            
        }
        return token
        
    }
    
    func getByEmail(email: String) -> User {
        var answer = "some error"
        let user = User()
        let parameters: [String: Any] = [
            "Email": email
            ]
        //let url2 = "http://api.openweathermap.org/data/2.5/weather"
        let url = "https://192.168.0.100:44334/user/getByEmail"
        
        sessionManager.request(url, method: .post, parameters: parameters).responseJSON{
            response in
            if response.result.isSuccess{
                answer = "Вход успешно выполнен!"
                let userJSON : JSON = JSON(response.result.value!)
                user.id = userJSON["uid"].string!
                user.email = userJSON["email"].string!
                user.passwordHash = userJSON["passwordHash"].string!
                user.passwordSalt = userJSON["passwordSalt"].string!
            }
            else{
                answer = "Ошибка в получении пользователя: \(response.result.error)"
            }
        }
        return user
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
