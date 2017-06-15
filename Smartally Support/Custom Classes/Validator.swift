//
//  Validator.swift
//  Smartally Support
//
//  Created by Muqtadir Ahmed on 24/05/17.
//  Copyright © 2017 Bitjini. All rights reserved.
//

import Foundation

class Validator {
    
    // Enums.
    enum Err: Error {
        case name, amount, date, username, password, passwordLength
    }
    
    static func validate(job: Job.Job) throws {
        if job.name.isEmpty   { throw Err.name }
        if job.amount.isEmpty { throw Err.amount }
        if job.date == nil { throw Err.date}
    }
    
    static func validate(credential: Registrar.Credential) throws {
        if credential.username.isEmpty { throw Err.username }
        if credential.password.isEmpty { throw Err.password }
        if credential.password.characters.count < 6 || credential.password.characters.count > 16 { throw Err.passwordLength }
    }
}
