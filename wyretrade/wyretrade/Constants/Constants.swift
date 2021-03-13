//
//  Constants.swift
//  wyretrade
//
//  Created by maxus on 3/8/21.
//

import Foundation
import UIKit
import DeviceKit

class Constants {
    struct  URL {
        
         static  let base = "https://www.joiintapp.com/";
             static  let api_url = "https://joiintapp.com/api/user";

             static  let REDIRECT_URL = base + "api/coinstock/";

             static  let login = REDIRECT_URL + "oauth/token";
             static  let register = REDIRECT_URL + "signup";

             static  let CHECK_MAIL_ALREADY_REGISTERED = api_url+"verify";
             static  let RESET_PASSWORD = REDIRECT_URL + "reset/password";
             static  let CHANGE_PASSWORD = REDIRECT_URL + "change/password";
             static  let FORGOT_PASSWORD = REDIRECT_URL + "forgot/password";
             static  let LOGOUT = api_url + "logout";
             static  let HELP = REDIRECT_URL + "help";

             static  let UserProfile = REDIRECT_URL+"profile";
             static  let UseProfileUpdate = REDIRECT_URL+"profile/update";
             static  let GET_USER_BALANCES = REDIRECT_URL + "balances";

             static  let COIN_DEPOSIT = REDIRECT_URL + "coin/deposit";
             static  let COIN_WITHDRAW = REDIRECT_URL + "coin/withdraw";
             static  let COIN_EXCHANGE = REDIRECT_URL + "coin/exchange";
             static  let COIN_REALEXCHANGE = REDIRECT_URL + "coin/realexchange";
             static  let COIN_REALEXCHANGE_LIST = REDIRECT_URL + "coin/realexchangelist";
             static  let COIN_REALEXCHANGE_DATA = REDIRECT_URL + "coin/realexchangedata";
             static  let COIN_REALEXCHANGE_HISTORY_DATA = REDIRECT_URL + "coin/realexchangedata/history";
             static  let COIN_REALEXCHANGE_CANCEL = REDIRECT_URL + "coin/realexchangecancel";
             static  let GET_ALL_COINS = REDIRECT_URL + "coins";
             static  let GET_BUY_COIN_ASSETS = REDIRECT_URL + "coin/buy_assets";
             static  let GET_SEND_COIN_ASSETS = REDIRECT_URL + "coin/send_assets";
             static  let GET_WITHDRAWBLE_COIN_ASSETS = REDIRECT_URL + "coin/withdraw_assets";
             static  let TRANSFER_COIN = REDIRECT_URL + "coin/transfer";
             static  let GET_USDC_BALANCE = REDIRECT_URL + "usdc/balance";
             static  let GET_HOME_DATA = REDIRECT_URL + "home";
             static  let ADD_TRANSFER_COIN_CONTACT = REDIRECT_URL + "coin/transfer/contact/add";
             static  let REMOVE_TRANSFER_COIN_CONTACT = REDIRECT_URL + "coin/transfer/contact/remove";

             static  let GET_ALL_STOCKS = REDIRECT_URL + "stocks";
             static  let GET_ALL_STOCKS_DAILY = REDIRECT_URL + "stocks/search/iex";
             static  let GET_ALL_STOCKS_AGGREGATE = REDIRECT_URL + "stocks/aggregates";
             static  let GET_STOCK_DETAIL = REDIRECT_URL + "stock/iex/detail";
             static  let GET_STOCK_NEWS = REDIRECT_URL + "stock/news/all";
             static  let REQUEST_STOCK_ORDER_CREATE = REDIRECT_URL + "stock/order/create";
             static  let REQUEST_STOCK_ORDER_REPLACE = REDIRECT_URL + "stock/order/replace";
             static  let REQUEST_STOCK_ORDER_CANCEL = REDIRECT_URL + "stock/order/cancel";
             static  let GET_STOCK_ORDER_INVESTED = REDIRECT_URL + "stock/order/status/user/invested/iex";
             static  let GET_STOCK_ORDER_PENDING = REDIRECT_URL + "stock/order/status/user/pending";
             static  let GET_STOCK_ORDER = REDIRECT_URL + "stock/order/status/user";
             static  let STOCK_WITHDRAW = REDIRECT_URL + "stock/withdraw";
             static  let REQUEST_DEPOSIT_STOCK = REDIRECT_URL + "stock/deposit";

             static  let GET_BANK_DETAIL = REDIRECT_URL + "bank/detail";
             static  let REQUEST_ADD_BANK = REDIRECT_URL + "bank/add";
             static  let REQUEST_REMOVE_FRIEND_BANK = REDIRECT_URL + "bank/friend/remove";
             static  let REQUEST_ADD_IBAN = REDIRECT_URL + "bank/assign/iban";
             static  let REQUEST_ADD_FRIEND_BANK = REDIRECT_URL + "bank/friend/add";
             static  let REQUEST_ADD_MONEY = REDIRECT_URL + "bank/money/add";
             static  let REQUEST_SEND_MONEY = REDIRECT_URL + "bank/money/send";
             static  let REQUEST_CONVERSION_RATE = REDIRECT_URL + "bank/currency/rate";
             static  let REQUEST_FRIEND_BANK_LIST = REDIRECT_URL + "bank/friend/list";

             static  let GET_PREDICTABLE_LIST = REDIRECT_URL + "predictable/list";
             static  let REQUEST_PREDICT = REDIRECT_URL + "predict";
             static  let REQUEST_PREDICT_BID = REDIRECT_URL + "predict/bid";
             static  let REQUEST_PREDICT_CANCEL = REDIRECT_URL + "predict/cancel";

             static  let GET_STAKE_BALANCE = REDIRECT_URL + "stake/balance";
             static  let GET_STAKE_LIST = REDIRECT_URL + "stake/list";
             static  let REQUEST_STAKE = REDIRECT_URL + "stake";
             static  let REQUEST_STAKE_RELEASE = REDIRECT_URL + "stake/release";

             static  let GET_MTN_SERVICE = REDIRECT_URL + "mtn";
             static  let GET_MTN_TRANSACTION = REDIRECT_URL + "mtn/transactions";
             static  let REQUEST_MTN_PAY = REDIRECT_URL + "mtn/pay";
             static  let REQUEST_MTN_TOPUP = REDIRECT_URL + "mtn/topup";
             static  let REQUEST_MTN_CONVERT = REDIRECT_URL + "mtn/convert";

             static  let ZABO_REDIRECT = REDIRECT_URL + "zaho/webhook";
             static  let GET_ZABO_ACCOUNTS = REDIRECT_URL + "zaho/accounts";
             static  let REQUEST_ZABO_ACCOUNTS = REDIRECT_URL + "zaho/accounts";
             static  let GET_ZABO_ACCOUNT = REDIRECT_URL + "zaho/account/";
             static  let REQUEST_ZABO_DEPOSIT = REDIRECT_URL + "zaho/deposit";
    }
    
    
    struct customCodes {

        static let purchaseCode = "Purchase Code"
        static let securityCode = "Secret Code"
    }
    
    struct googlePlacesAPIKey {
        static let placesKey =  "Places Key"
        
    }
    
    struct AppColor {
        static let greenColor = "#24a740"
        static let redColor = "#F25E5E"
        static let ratingColor = "#ffcc00"
        static let orangeColor = "#f58936"
        static let messageCellColor = "fffcf6"
        static let brownColor = "#90000000"
        static let expired = "#d9534f"
        static let active = "#4caf50"
        static let sold = "#3498db"
        static let featureAdd = "#d9534f"
        static let phoneVerified = "#8ac249"
        static let phoneNotVerified = "#F25E5E"
    }
    
    
    struct NotificationName {
        static let updateUserProfile = "updateProfile"
        static let updateAddDetails = "updateAds"
        static let updateBidsStats = "bidsStats"
        static let adPostImageDelete = "updateMainData"
        static let searchDynamicData = "UpdateDynamicData"
        static let updateAdPostDynamicData = "UpdateAdPostDynamicData"
    }
    
    struct NetworkError {
        static let timeOutInterval: TimeInterval = 20
        
        static let error = "Error"
        static let internetNotAvailable = "Internet Not Available"
        static let pleaseTryAgain = "Please Try Again"
        
        static let generic = 4000
        static let genericError = "Please Try Again."
        
        static let serverErrorCode = 5000
        static let serverNotAvailable = "Server Not Available"
        static let serverError = "Server Not Availabe, Please Try Later."
        
        static let timout = 4001
        static let timoutError = "Network Time Out, Please Try Again."
        
        static let login = 4003
        static let loginMessage = "Unable To Login"
        static let loginError = "Please Try Again."
        
        static let internet = 4004
        static let internetError = "Internet Not Available"
    }
    
    struct NetworkSuccess {
        static let statusOK = 200
    }
    
    struct activitySize {
        static let size = CGSize(width: 40, height: 40)
    }
    
    enum loaderMessages : String {
        case loadingMessage = ""
    }
    
    //Convert data to json string
    static func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    
    static func dateFormatter(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        let date = dateFormatter.date(from: date)
        // change to a readable time format and change to local time zone
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone.local
        let timeStamp = dateFormatter.string(from: date!)
        return timeStamp
    }
    
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    static func crossString (titleStr : String) -> NSMutableAttributedString {
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: titleStr)
        attributeString.addAttribute(NSAttributedString.Key.baselineOffset, value: 1, range: NSMakeRange(0, attributeString.length ))
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length  ))
        attributeString.addAttribute(NSAttributedString.Key.strikethroughColor, value: UIColor.black, range:  NSMakeRange(0, attributeString.length))
        return attributeString
    }
    
    static func attributedString(from string: String, nonBoldRange: NSRange?) -> NSAttributedString {
        let fontSize = UIFont.systemFontSize
        let attrs = [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: fontSize),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        let nonBoldAttribute = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize),
        ]
        let attrStr = NSMutableAttributedString(string: string, attributes: attrs)
        if let range = nonBoldRange {
            attrStr.setAttributes(nonBoldAttribute, range: range)
        }
        return attrStr
    }
    
    static func labelString(from string: String, nonBoldRange: NSRange?) -> NSAttributedString {
        let fontSize = UIFont.systemFontSize
        let attrs = [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: fontSize),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        let nonBoldAttribute = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize),
        ]
        let attrStr = NSMutableAttributedString(string: string, attributes: attrs)
        if let range = nonBoldRange {
            attrStr.setAttributes(nonBoldAttribute, range: range)
        }
        return attrStr
    }
    
    public static var isiPadDevice: Bool {
        
        let device = Device.current
        
        if device.isPad {
            return true
        }
        switch device {
        case .simulator(.iPad2), .simulator(.iPad3), .simulator(.iPad4), .simulator(.iPad5), .simulator(.iPadAir), .simulator(.iPadAir2), .simulator(.iPadMini), .simulator(.iPadMini2), .simulator(.iPadMini3), .simulator(.iPadMini4), .simulator(.iPadPro9Inch), .simulator(.iPadPro10Inch), .simulator(.iPadPro12Inch), .simulator(.iPadPro12Inch2), .iPadAir, .iPad5, .iPad4, .iPad3, .iPad2, .iPadAir, .iPadAir2, .iPadMini, .iPadMini2, .iPadMini3, .iPadMini4:
            return true
            
        default:
            return false
        }
    }
    
    public static var isiPhone5 : Bool {
        
        let device = Device.current
        
        switch device {
            
        case .simulator(.iPhone4), .simulator(.iPhone4s), .simulator(.iPhone5), .simulator(.iPhone5s), . simulator(.iPhone5c), .simulator(.iPhoneSE):
            return true
            
        case .iPhone4, .iPhone4s, .iPhone5, .iPhone5s, .iPhone5c, .iPhoneSE:
            return true
            
        default:
            return false
        }
    }
    
    public static var isIphone6 : Bool {
        let device = Device.current
        switch device {
        case .iPhone6 , .simulator(.iPhone6), .iPhone6s , .simulator(.iPhone6s) , .iPhone7, .simulator(.iPhone7), .iPhone8, .simulator(.iPhone8):
            return true
        default:
            return false
        }
    }
    
    public static var isIphonePlus : Bool {
        let device = Device.current
        switch device {
        case .iPhone6Plus, .simulator(.iPhone6Plus)  ,.iPhone7Plus, .simulator(.iPhone7Plus),.iPhone8Plus, .simulator(.iPhone8Plus):
            return true
        default:
            return false
        }
    }
    
    public static var isIphoneX : Bool {
        
        let device = Device.current
        
        switch device {
        case .iPhoneX, .simulator(.iPhoneX) :
            return true
        default:
            return false
        }
    }
    
    public static var isIphoneXR : Bool {
        
        let device = Device.current
        
        switch device {
        case .iPhoneX, .simulator(.iPhoneX) :
            return true
        default:
            return false
        }
    }
    
    public static var isSimulator: Bool {
        
        let device = Device.current
        
        if device.isSimulator {
            return true
        }
        else {
            return false
        }
    }
    
    
    static func setFontSize (size : Int) -> UIFont {
        let device = Device.current
        
        switch device {
        case .iPad2, .iPad3, .iPad4 , .iPad5 , .iPadAir, .iPadAir2, .iPadMini, .iPadMini2, .iPadMini3, .iPadMini4, .iPadPro9Inch, .iPadPro10Inch, .iPadPro12Inch, .iPadPro12Inch2:
            return UIFont(name: "System-Thin", size: CGFloat(size + 2))!
        case .iPhone4, .iPhone4s , .iPhone5, .iPhone5c, .iPhone5s:
            return UIFont (name: "System-Thin", size: CGFloat(size - 2))!
        default:
            return UIFont (name: "System-Thin", size: CGFloat(size))!
        }
    }
}
