//
//  NewsModel.swift
//  wyretrade
//
//  Created by maxus on 3/2/21.
//

import Foundation

struct NewsModel {
    var title: String!
    var image: String!
    var description: String!
    var date: String!
    
    init(fromDictionary dictionary: [String: Any]) {
        title = dictionary["title"] as? String
        image = dictionary["image"] as? String
        description = dictionary["description"] as? String
        date = dictionary["date"] as? String
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["title"] = title
        dictionary["image"] = image
        dictionary["description"] = description
        dictionary["date"] = date
        return dictionary
    }
}
