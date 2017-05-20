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
    // Http Utility Class' instance.
    lazy var http: HTTPUtility = {
        let http = HTTPUtility.shared
        http.delegate = self.delegate
        return http
    }()
    // Delegate.
    var delegate: HTTPUtilityDelegate?
    
    // URLs.
    private let baseURL = "https://smartallysupport.herokuapp.com/api/"
    
    fileprivate var register: String {
        get {
            return baseURL + "register/"
        }
    }
    
    fileprivate var login: String {
        get {
            return baseURL + "login/"
        }
    }
}

extension Middleware {
    // Login & Register.
    func register(username usn: String, password pwd: String) {
        let parameter = ["username" : usn, "password" : pwd]
        http.send(url: register, method: .post, parameters: parameter)
    }
    
    func login(username usn: String, password pwd: String) {
        let parameter = ["username" : usn, "password" : pwd]
        http.send(url: login, method: .post, parameters: parameter)
    }
}
