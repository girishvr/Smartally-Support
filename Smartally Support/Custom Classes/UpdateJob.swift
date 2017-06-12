//
//  UpdateJob.swift
//  Smartally Support
//
//  Created by Muqtadir Ahmed on 20/05/17.
//  Copyright © 2017 Bitjini. All rights reserved.
//

import Foundation
import Alamofire

protocol UpdateJobDelegate {
    func updated(jobWithID ID: String)
    func failed(withError error: String)
}

class UpdateJob {
    
    var ongoingJobID: String = ""
    
    // Delegate.
    var delegate: UpdateJobDelegate?
    
    // Class instance.
    lazy var middleware: Middleware = {
        let middleware = Middleware.shared
        middleware.http.delegate = self
        return middleware
    }()
    
    func updateJob(job: Job.Job) {
        // Create parameters.
        var parameter = [
            "name" : job.name,
            "amount" : job.amount,
            "user_id" : user.id
        ]
        
        if let date = job.date {
            parameter.updateValue(date.toISO(), forKey: "date")
        }
        
        if !job.invoice.isEmpty {
            parameter.updateValue(job.invoice, forKey: "invoice_no")
        }
        
        print(parameter)
        // Update.
        ongoingJobID = job.ID
        
        middleware.updateJob(withID: job.ID, parameters: parameter)
    }
}

extension UpdateJob: HTTPUtilityDelegate {
    
    func completedRequest(response: [String : AnyObject]) {
        guard let status = response["status"] as? Int else { failedRequest(response: "Status not available."); return }
        if status == 400 {
            failedRequest(response: response["message"] as? String ?? "Some error occurred.")
            return
        }
        delegate?.updated(jobWithID: ongoingJobID)
    }
    
    func failedRequest(response: String) {
        delegate?.failed(withError: response)
    }
}
