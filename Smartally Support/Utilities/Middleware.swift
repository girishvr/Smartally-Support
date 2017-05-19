//
//  Middleware.swift
//  Smartally Support
//
//  Created by Muqtadir Ahmed on 19/05/17.
//  Copyright © 2017 Bitjini. All rights reserved.
//

import UIKit

class Middleware {
    
    // Class' shared instance.
    static let shared = Middleware()
    // Delegate.
    //var delegate:
    
    // URLs.
    private let baseURL = "https://smartallysupport.herokuapp.com/api/"
    
    fileprivate var register: URL? {
        get {
            return URL(string: baseURL + "register/")
        }
    }
    
    fileprivate var login: URL? {
        get {
            return URL(string: baseURL + "login/")
        }
    }
}

extension Middleware {
    
    func register(username usn: String, password pwd: String) {
        
    }
    
    func login(username usn: String, password pwd: String) {
        
    }
}
