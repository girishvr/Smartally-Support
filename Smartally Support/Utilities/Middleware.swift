//
//  Middleware.swift
//  Smartally Support
//
//  Created by Muqtadir Ahmed on 19/05/17.
//  Copyright © 2017 Bitjini. All rights reserved.
//

import FirebaseMessaging
import UIKit

class Middleware {
    
    // Class' shared instance.
    static let shared = Middleware()
    // Http Utility Class' instance.
    lazy var http: HTTPUtility = {
        let http = HTTPUtility.shared
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
    
    fileprivate var get: String {
        get {
            return baseURL + "job/"
        }
    }
    
    fileprivate var update: String {
        get {
            return baseURL + "job?id="
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
        let parameter = ["username" : usn, "password" : pwd, "identifier" : Messaging.messaging().fcmToken ?? ""]
        http.send(url: login, method: .post, parameters: parameter)
    }
}

extension Middleware {
    // Get & Update Jobs.
    func getJobs() {
        http.send(url: get, method: .get)
    }
    
    func updateJob(withID id: String, parameters: [String : String]) {
        http.send(url: update + id, method: .put, parameters: parameters)
    }
}
