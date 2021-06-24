//
//  AppDelegate.swift
//  wyretrade
//
//  Created by maxus on 2/28/21.
//

import UIKit
import SlideMenuControllerSwift
import Firebase
import PayPalCheckout

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        FirebaseOptions.defaultOptions()?.deepLinkURLScheme = "wyretrade.page.link"
        FirebaseApp.configure()
        let config = CheckoutConfig(
                clientID: "AR2Siw3fi8ZVqIvRRg10-_fO8n1jA8z-ZYyilZnaXsA3xFW6Y4e5MA15_KYIxYnKRPTdt3K_JhbUC-Q4",
                returnUrl: "https://wyretrade.com",
            environment: .sandbox
            )

            Checkout.set(config: config)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate {
    func application(_ app: UIApplication, open url: URL, options:
                        [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        if let isDynamicLink = DynamicLinks.dynamicLinks().shouldHandleDynamicLink(fromCustomSchemeURL: url), isDynamicLink {
            let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url)
            return handleDynamicLink(dynamicLink)
//      }
      // Handle incoming URL with other methods as necessary
      // ...
//      return false
    }

    @available(iOS 8.0, *)
    func application(_ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
       let dynamicLinks = DynamicLinks.dynamicLinks()
      let handled = dynamicLinks.handleUniversalLink(userActivity.webpageURL!) { (dynamicLink, error) in
        if (dynamicLink != nil) && !(error != nil) {
          self.handleDynamicLink(dynamicLink)
        }
      }
      if !handled {
        // Handle incoming URL with other methods as necessary
        // ...
      }
      return handled
    }

    func handleDynamicLink(_ dynamicLink: DynamicLink?) -> Bool {
      guard let dynamicLink = dynamicLink else { return false }
      guard let deepLink = dynamicLink.url else { return false }
      let queryItems = URLComponents(url: deepLink, resolvingAgainstBaseURL: true)?.queryItems
      let invitedBy = queryItems?.filter({(item) in item.name == "invitedby"}).first?.value
        
        let defaults = UserDefaults.standard
        defaults.set(invitedBy, forKey: "invitedBy")
        defaults.synchronize()
      return true
    }
}



extension AppDelegate {
    func moveToMain() {
//        let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = storyboard.instantiateViewController(withIdentifier: "MainController") as! MainController
        let leftVC = storyboard.instantiateViewController(withIdentifier: "LeftController") as! LeftController
        let navi : UINavigationController = UINavigationController(rootViewController: mainVC)
        let slideMenuController = SlideMenuController(mainViewController: navi, leftMenuViewController: leftVC)
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
    }
    
    func moveToLogin() {
//        let storyboard1 = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "SigninController") as! SigninController
        let nav: UINavigationController = UINavigationController(rootViewController: loginVC)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
    }
}


