//
//  Middleware.swift
//  Smartally Support
//
//  Created by Muqtadir Ahmed on 19/05/17.
//  Copyright © 2017 Bitjini. All rights reserved.
//

import FirebaseMessaging
import UIKit
import Alamofire

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
    private let baseURL = "https://reimburse.herokuapp.com/"
    
    fileprivate var register: String {
        get {
            return baseURL + "support_register/"
        }
    }
    
    fileprivate var login: String {
        get {
            return baseURL + "support_login/"
        }
    }
    
    fileprivate var get: String {
        get {
            return baseURL + "get_incomplete_jobs/?access_token=" + user.accessToken
        }
    }
    
    fileprivate var update: String {
        get {
            return baseURL + "update_job/?id="
        }
    }
    
    fileprivate var identifier: String {
        get {
            return baseURL + "updateID?id=" + user.id
        }
    }
}

extension Middleware {
    // Login & Register.
    func register(username usn: String, password pwd: String) {
         let parameter = ["username" : usn, "password" : pwd, "identifier" : Messaging.messaging().fcmToken ?? "","platform" : "ios"]
        print(parameter)

        http.send(url: register, method: .post, parameters: parameter)
    }
    
    func login(username usn: String, password pwd: String) {
        let parameter = ["username" : usn, "password" : pwd]
        print(parameter)
        http.send(url: login, method: .post, parameters: parameter)
    }
    
    func update(token: String) {
        let parameter = ["identifier" : token]
        http.send(url: identifier, method: .put, parameters: parameter)
    }
}

extension Middleware {
    // Get & Update Jobs.
    func getJobs() {
        http.send(url: get, method: .get)
    }
    
    func updateJob(withID id: String, parameters: [String : String]) {
        http.send(url: update + id + "&access_token=" + user.accessToken, method: .put, parameters: parameters)
    }
}
