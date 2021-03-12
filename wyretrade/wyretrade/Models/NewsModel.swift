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
        description = dictionary["text"] as? String
        var publishedDate = dictionary["publishedDate"] as! String
//        let start = publishedDate.index(publishedDate.startIndex, offsetBy: 0)
//        let end = publishedDate.index(publishedDate.startIndex, offsetBy: 10)
//        date = String(publishedDate[start..<end])
        date = publishedDate.date
    }
    
    func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["title"] = title
        dictionary["image"] = image
        dictionary["text"] = description
        dictionary["publishedDate"] = date
        return dictionary
    }
}
