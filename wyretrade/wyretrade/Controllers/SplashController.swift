//
//  SplashController.swift
//  wyretrade
//
//  Created by maxus on 3/7/21.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import SlideMenuControllerSwift

class SplashController: UIViewController {
    
    var window: UIWindow?
    
    
    
    var defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        self.checkLogin()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func checkLogin() {

        if defaults.bool(forKey: "isLogin") {
//            self.appDelegate.moveToMain()
            var data = defaults.object(forKey: "userAuthData")
            let objUser = NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as! [String: Any]
            let userAuth = UserAuthModel(fromDictionary: objUser)
            guard let token = userAuth.access_token else {
                self.moveToLogin()
                return
            }
            if userAuth.isCompleteProfile {
                self.moveToMain()
            }
            else {
                self.moveToCompleteProfile()
            }
        }
        else {
//            self.appDelegate.moveToLogin()
            self.moveToLogin()
        }
    }
    
    func moveToMain() {

        let mainVC = storyboard?.instantiateViewController(withIdentifier: "MainController") as! MainController
         let leftVC = storyboard?.instantiateViewController(withIdentifier: "LeftController") as! LeftController
//         let navi : UINavigationController = UINavigationController(rootViewController: mainVC)
         let slideMenuController = SlideMenuController(mainViewController: mainVC, leftMenuViewController: leftVC)
        
        self.window?.rootViewController = slideMenuController
                self.window?.makeKeyAndVisible()
        navigationController?.pushViewController(slideMenuController, animated: true)
    }
    
    func moveToLogin() {

        let loginVC = storyboard?.instantiateViewController(withIdentifier: "SigninController") as! SigninController
//        let nav: UINavigationController = UINavigationController(rootViewController: loginVC)
//        self.window?.rootViewController = nav
//        self.window?.makeKeyAndVisible()
        navigationController?.pushViewController(loginVC, animated: true)
    }

    func moveToCompleteProfile() {

        let profileVC = storyboard?.instantiateViewController(withIdentifier: "ProfileEditController") as! ProfileEditController
//        let nav: UINavigationController = UINavigationController(rootViewController: profileVC)
//        self.window?.rootViewController = nav
//        self.window?.makeKeyAndVisible()
        navigationController?.pushViewController(profileVC, animated: true)
    }
}
