//
//  User.swift
//  Smartally Support
//
//  Created by Muqtadir Ahmed on 19/05/17.
//  Copyright © 2017 Bitjini. All rights reserved.
//

import UIKit

class User {
    
    static let defaults = UserDefaults.standard
    static var id: String   = ""
    static var name: String = ""
    
    static func logIn(user: [String : String]) {
        // Store values in class for app access.
        if let name = user["username"] {
            self.name = name
        }
        
        if let id = user["id"] {
            self.id = id
        }
        
        // Store values in UserDefaults for access after the app is relaunched.
        defaults.set(user, forKey: "user")
        // Log user in.
        defaults.set(true, forKey: "isLoggedIn")
        // Change view.
        changeRoot()
    }
    
    static func logOut() {
        // Log user out.
        defaults.set(false, forKey: "isLoggedIn")
        // Remove existing user's information.
        defaults.removeObject(forKey: "user")
        // Change view.
        changeRoot()
    }
    
    static func changeRoot() {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
        delegate.isLoggedIn()
    }
}
