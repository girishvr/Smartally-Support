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
    
    static var shared: Registrar = Registrar()
    
    // Middleware.
    lazy var middleware: Middleware = {
        let middleware = Middleware()
        middleware.delegate = self
        return middleware
    }()

    // Delegate.
    var delegate: RegistrarDelegate?
    
    // Send request.
    func send(shouldLogin: Bool, username: String, password: String) {
        shouldLogin ? middleware.login(username: username, password: password) : middleware.register(username: username, password: password)
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
        if status == 1 {
            return
        }
        
        guard let user = data["user"] as? [String : String] else { failedRequest(response: "No user info recieved."); return }
        User.logIn(user: user)
    }
}
