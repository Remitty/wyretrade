//
//  RequestHandler.swift
//  wyretrade
//
//  Created by maxus on 3/8/21.
//

import Foundation
import Alamofire

class RequestHandler {
    static let sharedInstance = RequestHandler()
    
    class func loginUser(parameter: NSDictionary, success: @escaping(UserRegisterRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.login
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            UserDefaults.standard.set(data, forKey: "userData")
            UserDefaults.standard.synchronize()
            let objLogin = UserRegisterRoot(fromDictionary: dictionary)
            success(objLogin)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
}
