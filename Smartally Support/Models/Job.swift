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
        var date: Date?
        var invoice: String = ""
        
        init(with jobJSON: [String : AnyObject]) {
            if let value = jobJSON["_id"] as? String { ID = value }
            
            if let value = jobJSON["imageEp"] as? String { imageEp = URL(string: value) }
            
            if let value = jobJSON["name"] as? String { name = value }
            
            if let value = jobJSON["amount"] as? String { amount = value }
            
            if let value = jobJSON["invoiceNo"] as? String { invoice = value }
            
            if let value = jobJSON["billDate"] as? String {
                guard let date = value.ISOToDate() else { return }
                self.date = date
            }
        }
    }
    
    // Container.
    static var jobs = [Job]()
    
    // Modifiers.
    static func deleteJob(byID ID: String) {
        jobs = jobs.filter({ $0.ID != ID })
    }
}

extension Job.Job: Equatable {
    static func ==(lhs: Job.Job, rhs: Job.Job) -> Bool {
        return lhs.ID == rhs.ID
    }
}




