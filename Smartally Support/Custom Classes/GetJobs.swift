//
//  GetJobs.swift
//  Smartally Support
//
//  Created by Muqtadir Ahmed on 20/05/17.
//  Copyright © 2017 Bitjini. All rights reserved.
//

import Foundation

protocol GetJobDelegate {
    func reload()
    func failed(withError error: String)
}

class GetJob {
    
    // Delegate.
    open var delegate: GetJobDelegate?
    
    // Class Instances.
    lazy var middleware: Middleware = {
        var middleware = Middleware()
        middleware.delegate = self
        return middleware
    }()
    
    // Fetch jobs from server.
    func getJobs() {
        middleware.getJobs()
    }
}

extension GetJob: HTTPUtilityDelegate {
    
    func completedRequest(response: [String : AnyObject]) {
        guard let status = response["status"] as? Int else { failedRequest(response: "Status not available."); return }
        if status == 1 {
            failedRequest(response: response["message"] as? String ?? "Some error occurred.")
            return
        }
        guard let jobs = response["jobs"] as? [[String : AnyObject]] else { failedRequest(response: "No jobs received."); return }
        Job.jobs = jobs.map({ Job.Job(with: $0) })
        delegate?.reload()
    }
    
    func failedRequest(response: String) {
        delegate?.failed(withError: response)
    }
}
