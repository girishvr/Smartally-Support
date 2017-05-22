//
//  UpdateJob.swift
//  Smartally Support
//
//  Created by Muqtadir Ahmed on 20/05/17.
//  Copyright © 2017 Bitjini. All rights reserved.
//

import Foundation

protocol UpdateJobDelegate {
    func updated()
    func failed(withError error: String)
}

class UpdateJob {
    
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
        let parameter = [
            "name" : job.name,
            "amount" : job.amount,
            "userid" : User.id
        ]
        // Update.
        middleware.updateJob(withID: job.ID, parameters: parameter)
    }
}

extension UpdateJob: HTTPUtilityDelegate {
    
    func completedRequest(response: [String : AnyObject]) {
        guard let status = response["status"] as? Int else { failedRequest(response: "Status not available."); return }
        if status == 1 {
            failedRequest(response: response["message"] as? String ?? "Some error occurred.")
            return
        }
        delegate?.updated()
    }
    
    func failedRequest(response: String) {
        delegate?.failed(withError: response)
    }
}
