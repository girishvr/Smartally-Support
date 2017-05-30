//
//  User.swift
//  Smartally Support
//
//  Created by Muqtadir Ahmed on 19/05/17.
//  Copyright © 2017 Bitjini. All rights reserved.
//

import UIKit

let user = User()

class User {
    
    let defaults = UserDefaults.standard
    var id: String   = ""
    var name: String = ""
    
    init() {
        guard let user = defaults.object(forKey: "user") as? [String : String] else { return }
        updateUserDetails(user: user)
    }
    
    func updateUserDetails(user: [String : String]) {
        // Store values in class for app access.
        if let name = user["username"] {
            self.name = name
        }
        
        if let id = user["id"] {
            self.id = id
        }
    }
    
    func logIn(user: [String : String]) {
        updateUserDetails(user: user)
        // Store values in UserDefaults for access after the app is relaunched.
        defaults.set(user, forKey: "user")
        // Log user in.
        defaults.set(true, forKey: "isLoggedIn")
        // Change view.
        changeRoot()
    }
    
    func logOut() {
        // Log user out.
        defaults.set(false, forKey: "isLoggedIn")
        // Remove existing user's information.
        defaults.removeObject(forKey: "user")
        // Change view.
        changeRoot()
    }
    
    func changeRoot() {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
        delegate.isLoggedIn()
    }
}
