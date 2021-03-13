//
//  NumberFormatter.swift
//  wyretrade
//
//  Created by maxus on 3/11/21.
//

import Foundation

struct CoinFormat: Codable {
    var value: Double
    var decimal: Int
}

struct PriceFormat: Codable {
    var amount: Double
    var currency: Currency
}

enum Currency: String, Codable {
    case eur
    case usd
    case sek
    case pln
}

extension CoinFormat: CustomStringConvertible {
    var description: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = decimal
        
        let number = NSNumber(value: value)
        
        return formatter.string(from: number)!
    }
}

extension PriceFormat: CustomStringConvertible {
    var description: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currency.rawValue
        formatter.maximumFractionDigits = 2

        let number = NSNumber(value: amount)
        return formatter.string(from: number)!
    }
}
