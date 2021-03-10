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
    
    class func loginUser(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.login
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, false, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objLogin = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func registerUser(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.register
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, false, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func forgotPassword(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.FORGOT_PASSWORD
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, false, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func resetPassword(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.RESET_PASSWORD
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, false, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func changePassword(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.CHANGE_PASSWORD
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func getProfile(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.UserProfile
        print(url)
        NetworkHandler.getRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func profileUpdate(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.UseProfileUpdate
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func getHome(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.GET_HOME_DATA
        print(url)
        NetworkHandler.getRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func getUserBalance(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.GET_USER_BALANCES
        print(url)
        NetworkHandler.getRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func getCoins(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.GET_ALL_COINS
        print(url)
        NetworkHandler.getRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func coinDeposit(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.COIN_DEPOSIT
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func getCoinDepositList(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.COIN_DEPOSIT
        print(url)
        NetworkHandler.getRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    class func coinExchange(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.COIN_EXCHANGE
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func getCoinExchangeList(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.COIN_EXCHANGE
        print(url)
        NetworkHandler.getRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func coinExchangeBuyAssets(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.GET_BUY_COIN_ASSETS
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func coinExchangeSendAssets(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.GET_SEND_COIN_ASSETS
        print(url)
        NetworkHandler.getRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func coinWithdraw(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.COIN_WITHDRAW
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func getCoinWithdrawList(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.COIN_WITHDRAW
        print(url)
        NetworkHandler.getRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func getCoinWithdrawableAssets(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.GET_WITHDRAWBLE_COIN_ASSETS
        print(url)
        NetworkHandler.getRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func xmtTrade(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.COIN_REALEXCHANGE
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func xmtTradeList(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.COIN_REALEXCHANGE_LIST
        print(url)
        NetworkHandler.getRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func xmtTradeData(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.COIN_REALEXCHANGE_DATA
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func xmtTradeHistory(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.COIN_REALEXCHANGE_HISTORY_DATA
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func xmtTradeCancel(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.COIN_REALEXCHANGE_CANCEL
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func getUSDCBalance(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.GET_USDC_BALANCE
        print(url)
        NetworkHandler.getRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func coinTransfer(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.TRANSFER_COIN
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func coinTransferList(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.TRANSFER_COIN
        print(url)
        NetworkHandler.getRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func coinTransferAddContact(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.ADD_TRANSFER_COIN_CONTACT
        print(url)
        NetworkHandler.getRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func coinTransferRemoveContact(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.REMOVE_TRANSFER_COIN_CONTACT
        print(url)
        NetworkHandler.getRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func getStakeBalance(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.GET_STAKE_BALANCE
        print(url)
        NetworkHandler.getRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func stake(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.REQUEST_STAKE
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func getStakeList(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.GET_STAKE_LIST
        print(url)
        NetworkHandler.getRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func stakeRelease(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.REQUEST_STAKE_RELEASE
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func getStockDetail(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.GET_STOCK_DETAIL
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func searchStocks(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.GET_ALL_STOCKS_DAILY
        print(url)
        NetworkHandler.getRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func getStocksAggregates(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.GET_ALL_STOCKS_AGGREGATE
        print(url)
        NetworkHandler.getRequest(url: url, parameters: parameter as? Parameters, false, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func getStockNews(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.GET_STOCK_NEWS
        print(url)
        NetworkHandler.getRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func createStocksOrder(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.REQUEST_STOCK_ORDER_CREATE
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func replaceStocksOrder(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.REQUEST_STOCK_ORDER_REPLACE
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func cancelStocksOrder(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.REQUEST_STOCK_ORDER_CANCEL
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func getInvestedStocks(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.GET_STOCK_ORDER_INVESTED
        print(url)
        NetworkHandler.getRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func getPendingStocks(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.GET_STOCK_ORDER_PENDING
        print(url)
        NetworkHandler.getRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func getAllOrderStocks(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.GET_STOCK_ORDER
        print(url)
        NetworkHandler.getRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func depositStocks(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.REQUEST_DEPOSIT_STOCK
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func withdrawStocks(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.STOCK_WITHDRAW
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func withdrawStocksList(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.STOCK_WITHDRAW
        print(url)
        NetworkHandler.getRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func getBankDetail(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.GET_BANK_DETAIL
        print(url)
        NetworkHandler.getRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func addBank(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.REQUEST_ADD_BANK
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func removeBankFriend(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.REQUEST_REMOVE_FRIEND_BANK
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func addIBAN(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.REQUEST_ADD_IBAN
        print(url)
        NetworkHandler.getRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func addBankFriend(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.REQUEST_ADD_FRIEND_BANK
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func addBankMoney(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.REQUEST_ADD_MONEY
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func sendBankMoney(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.REQUEST_SEND_MONEY
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func getBankFriendList(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.REQUEST_FRIEND_BANK_LIST
        print(url)
        NetworkHandler.getRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func getBankCurrencyRate(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.REQUEST_CONVERSION_RATE
        print(url)
        NetworkHandler.getRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    class func getPredictionList(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.GET_PREDICTABLE_LIST
        print(url)
        NetworkHandler.getRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func predict(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.REQUEST_PREDICT
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func bidPredict(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.REQUEST_PREDICT_BID
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func cancelPredict(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.REQUEST_PREDICT_CANCEL
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func getMtnService(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.GET_MTN_SERVICE
        print(url)
        NetworkHandler.getRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func getMtnTransactions(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.GET_MTN_TRANSACTION
        print(url)
        NetworkHandler.getRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func payMtn(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.REQUEST_MTN_PAY
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func topupMtn(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.REQUEST_MTN_TOPUP
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func convertMtn(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.REQUEST_MTN_CONVERT
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func zaboRedirect(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.ZABO_REDIRECT
        print(url)
        NetworkHandler.getRequest(url: url, parameters: parameter as? Parameters, false, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func getZaboAccounts(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.GET_ZABO_ACCOUNTS
        print(url)
        NetworkHandler.getRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func createZaboAccount(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.REQUEST_ZABO_ACCOUNTS
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func getZaboAccountDetail(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.GET_ZABO_ACCOUNT
        print(url)
        NetworkHandler.getRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }

    class func createZaboDeposit(parameter: NSDictionary, success: @escaping(UserModel)-> Void, failure: @escaping(NetworkError)-> Void) {
        let url = Constants.URL.REQUEST_ZABO_DEPOSIT
        print(url)
        NetworkHandler.postRequest(url: url, parameters: parameter as? Parameters, true, success: { (successResponse) in
            // let dictionary = successResponse as! [String: Any]
            // let data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
            // UserDefaults.standard.set(data, forKey: "userData")
            // UserDefaults.standard.synchronize()
            // let objRegister = UserModel(fromDictionary: dictionary)
            success(successResponse)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
        
}