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
        case name, amount
    }
    
    static func validate(job: Job.Job) throws {
        if job.name.isEmpty   { throw Err.name }
        if job.amount.isEmpty { throw Err.amount }
    }
    
}
