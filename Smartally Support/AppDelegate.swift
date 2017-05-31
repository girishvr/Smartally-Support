//
//  AppDelegate.swift
//  Smartally Support
//
//  Created by Muqtadir Ahmed on 19/05/17.
//  Copyright © 2017 Bitjini. All rights reserved.
//

import Firebase
import IQKeyboardManagerSwift
import Kingfisher
import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Configure Firebase.
        FirebaseApp.configure()
        registerRemoteNotifications(application)
        // IQKeyboardManager preferences.
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        // Show login screen if app isn't logged in.
        isLoggedIn()
        return true
    }
    // Firebase register for remote notifications.
    func registerRemoteNotifications(_ application: UIApplication) {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
            Messaging.messaging().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
        }
            
        else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
    }
    
    // Token Refresh Delegate.
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            Middleware().update(token: fcmToken)
        }
    }
    
    // Login flow.
    func isLoggedIn() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        let root = !UserDefaults.standard.bool(forKey: "isLoggedIn") ?
            storyboard.instantiateViewController(withIdentifier: "LoginRegisterViewController") as! LoginRegisterViewController :
            storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let nav = UINavigationController(rootViewController: root)
        nav.navigationBar.tintColor = .darkGray
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print(userInfo)
        delegate?.getJobs()
    }
    
    func applicationWillResignActive(_      application: UIApplication) {}
    func applicationDidEnterBackground(_    application: UIApplication) {}
    func applicationWillEnterForeground(_   application: UIApplication) {}
    func applicationDidBecomeActive(_       application: UIApplication) {}
    func applicationWillTerminate(_         application: UIApplication) {}
}

public extension UINavigationController {
    
}

