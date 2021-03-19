//
//  UserModel.swift
//  wyretrade
//
//  Created by maxus on 3/6/21.
//

import Foundation
struct UserAuthModel {
    var first_name: String!
    var last_name: String!
    var email: String!
    var access_token: String!
    var isCompleteProfile: Bool!
    var id: String!
    var otp: String!
    
    init(fromDictionary dictionary: [String: Any]) {
        first_name = dictionary["first_name"] as! String
        last_name = dictionary["last_name"] as! String
        email = dictionary["email"] as! String
        access_token = dictionary["access_token"] as? String
        isCompleteProfile = dictionary["isCompleteProfile"] as? Bool
        if let idTemp = dictionary["id"] {
            id = "\(dictionary["id"]!)"
        }

        if let otpTemp = dictionary["otp"] {
            otp = "\(dictionary["otp"]!)"
        }
        
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["first_name"] = first_name
        dictionary["last_name"] = last_name
        dictionary["email"] = email
        dictionary["access_token"] = access_token
        dictionary["isCompleteProfile"] = isCompleteProfile
        
        return dictionary
    }
}
