//
//  Registrar.swift
//  Smartally Support
//
//  Created by Muqtadir Ahmed on 19/05/17.
//  Copyright © 2017 Bitjini. All rights reserved.
//

import UIKit

protocol RegistrarDelegate {
    func failed(withError error: String)
}

class Registrar {
    
    // Structs.
    struct Credential {
        var username: String
        var password: String
        
        init(username: String, password: String) {
            self.username = username
            self.password = password
        }
    }
    
    // Middleware.
    lazy var middleware: Middleware = {
        let middleware = Middleware.shared
        middleware.http.delegate = self
        return middleware
    }()
    
    // Delegate.
    var delegate: RegistrarDelegate?
    // Credential.
    var credential: Credential
    // Flag to determine which action to perform.
    var shouldRegister: Bool
    
    // Init.
    init(credential: Credential, shouldRegister: Bool) {
        self.credential = credential
        self.shouldRegister = shouldRegister
        self.send()
    }
    
    // Send request.
    fileprivate func send() {
        shouldRegister ?
            middleware.register(username: credential.username, password: credential.password) :
            middleware.login(username: credential.username, password: credential.password)
    }
}

extension Registrar: HTTPUtilityDelegate {
    
    func completedRequest(response: [String : AnyObject]) {
        validate(data: response)
    }
    
    func failedRequest(response: String) {
        delegate?.failed(withError: response)
    }
    
    func validate(data: [String : AnyObject]) {
        guard let status = data["status"] as? Int else { failedRequest(response: "No status recieved."); return }
        if status == 400 {
            failedRequest(response: data["message"] as? String ?? "Some error occurred.")
            return
        }
        
        // Login.
        if shouldRegister {
            shouldRegister = !shouldRegister
            send()
            return
        }
        
        guard let _user = data["user_details"] as? [String : AnyObject] else { failedRequest(response: "No user info recieved."); return }
        print(_user)
        user.logIn(user: _user)
    }
}
