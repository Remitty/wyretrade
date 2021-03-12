//
//  NetworkHandler.swift
//  wyretrade
//
//  Created by maxus on 3/8/21.
//

import Foundation
import Alamofire

class NetworkHandler {

    class func postRequest(url: String, parameters: Parameters?, isAuth: Bool, success: @escaping (Any) -> Void, failure: @escaping (NetworkError) -> Void) {
       
        if Network.isAvailable {
            var headers: HTTPHeaders
            if isAuth {
                
                let data = UserDefaults.standard.object(forKey: "userAuthData")
                let objUser = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as! [String: Any]
                let userAuth = UserAuthModel(fromDictionary: objUser)
                var userAuthToken = userAuth.access_token!
                headers = [
                "Accept": "application/json",
                "Authorization": "Bearer \(userAuthToken)"
                ]
            } else {
                
                headers = [
                    "Accept": "application/json"
                    ]
            }
            print(headers)
            let manager = Alamofire.Session.default
            manager.session.configuration.timeoutIntervalForRequest = Constants.NetworkError.timeOutInterval
            print(Parameters.self)
            manager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<600).responseJSON
                { (response) -> Void in
                    
                print("response \(response)")
                
 
                    guard let statusCode = response.response?.statusCode else {
                        var networkError = NetworkError()
                        
                        networkError.status = Constants.NetworkError.timout
                        networkError.message = Constants.NetworkError.timoutError
                        
                        failure(networkError)
                        return
                        
                    }
                
                    if statusCode != 200 {
                        
                        var networkError = NetworkError()
                        
                        let response = response.value!
                        
                        if response is String {
                            networkError.status = statusCode
                            networkError.message = response as! String
                            
                            failure(networkError)
                            
                            return
                        }
                        
                        let dictionary = response as! [String: AnyObject]
                        guard let message = dictionary["error"] as! String? else {
                            networkError.status = statusCode
                            networkError.message = "Validation Error"
                            
                            failure(networkError)
                            
                            return
                        }
                        networkError.status = statusCode
                        networkError.message = message
                        
                        failure(networkError)
                        
                        
                    }else{
                        
                        switch (response.result) {
                        case .success:
                            let response = response.value!
                            
                            success(response)
                            break
                        case .failure(let error):
                            var networkError = NetworkError()
                            
                            if error._code == NSURLErrorTimedOut {
                                networkError.status = Constants.NetworkError.timout
                                networkError.message = Constants.NetworkError.timoutError
                                
                                failure(networkError)
                            } else {
                                networkError.status = Constants.NetworkError.generic
                                networkError.message = Constants.NetworkError.genericError
                                
                                failure(networkError)
                            }
                            break
                        }
                    }
                }
        } else {
            let networkError = NetworkError(status: Constants.NetworkError.internet, message: Constants.NetworkError.internetError)
            failure(networkError)
        }
    }
    
    class func getRequest(url: String, parameters: Parameters?, isAuth: Bool, success: @escaping (Any?) -> Void, failure: @escaping (NetworkError) -> Void) {
        
        let manager = Alamofire.Session.default
        manager.session.configuration.timeoutIntervalForRequest = Constants.NetworkError.timeOutInterval
        
       var headers: HTTPHeaders
        if isAuth {
            let data = UserDefaults.standard.object(forKey: "userAuthData")
            let objUser = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as! [String: Any]
            let userAuth = UserAuthModel(fromDictionary: objUser)
            var userAuthToken = userAuth.access_token!
            headers = [
                "Accept": "application/json",
                "Authorization": "Bearer \(userAuthToken)",
                ]
            } else {

                headers = [
                    "Accept": "application/json",
                    ]
            }
        
        manager.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) -> Void in
      
            debugPrint(response)
            print(response)
            guard let statusCode = response.response?.statusCode else {
                var networkError = NetworkError()
                
                networkError.status = Constants.NetworkError.timout
                networkError.message = Constants.NetworkError.timoutError
                
                failure(networkError)
                return
                
            }
        
            if statusCode != 200 {
                var networkError = NetworkError()
                
                let response = response.value!
                if response is String {
                    networkError.status = statusCode
                    networkError.message = response as! String
                    
                    failure(networkError)
                    
                    return
                }
                
                let dictionary = response as! [String: AnyObject]
                guard let message = dictionary["error"] as! String? else {
                    networkError.status = statusCode
                    networkError.message = "Validation Error"
                    
                    failure(networkError)
                    
                    return
                }
                networkError.status = statusCode
                networkError.message = message
                
                failure(networkError)
                
                
            }
            else {
                switch response.result{
                //Case 1
                case .success:
                    let response = response.value
                    success(response)
                    break
                case .failure (let error):
                    var networkError = NetworkError()
                    if error._code == NSURLErrorTimedOut {
                        networkError.status = Constants.NetworkError.timout
                        networkError.message = Constants.NetworkError.timoutError
                        
                        failure(networkError)
                    } else {
                        networkError.status = Constants.NetworkError.generic
                        networkError.message = Constants.NetworkError.genericError
                        
                        failure(networkError)
                    }
                    break
                }
            }
        }
    }
    
}

struct NetworkError {
    var status: Int = Constants.NetworkError.generic
    var message: String = Constants.NetworkError.genericError
}

struct NetworkSuccess {
    var status: Int = Constants.NetworkError.generic
    var message: String = Constants.NetworkError.genericError
}
