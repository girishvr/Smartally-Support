//
//  Job.swift
//  Smartally Support
//
//  Created by Muqtadir Ahmed on 19/05/17.
//  Copyright © 2017 Bitjini. All rights reserved.
//

import Foundation

class Job {
    
    // Struct.
    struct Job {
        var ID: String = ""
        var imageEp: URL?
        var name: String = ""
        var amount: String = ""
        
        init(with jobJSON: [String : AnyObject]) {
            if let value = jobJSON["_id"] as? String { ID = value }
            
            if let value = jobJSON["imageEp"] as? String { imageEp = URL(string: value) }
            
            if let value = jobJSON["name"] as? String { name = value }
            
            if let value = jobJSON["amount"] as? String { amount = value }
        }
    }
    
    // Container.
    static var jobs = [Job]()
}

extension Job.Job: Equatable {
    static func ==(lhs: Job.Job, rhs: Job.Job) -> Bool {
        return lhs.ID == rhs.ID
    }
}


