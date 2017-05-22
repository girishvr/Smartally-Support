//
//  HTTPUtility.swift
//  Smartally Support
//
//  Created by Muqtadir Ahmed on 19/05/17.
//  Copyright © 2017 Bitjini. All rights reserved.
//

import Alamofire

protocol HTTPUtilityDelegate {
    func completedRequest(response: [String : AnyObject])
    func failedRequest(response: String)
}

class HTTPUtility {
    
    static let shared = HTTPUtility()
    
    // Delegate.
    var delegate: HTTPUtilityDelegate?
    // Current request.
    var request: DataRequest?
}

extension HTTPUtility {
    
    func send(url: String, method: HTTPMethod, parameters: Parameters? = nil, headers: HTTPHeaders? = nil) {
        request = Alamofire
            .request(url,
                     method: method,
                     parameters: parameters,
                     headers: headers)
            .responseJSON() { (response) in
                switch response.result {
                case .success:
                    self.success(response.result.value)
                case .failure(let error):
                    self.failure(error)
                }
        }
    }
    
    private func success(_ data: Any?) {
        guard let data = data as? [String : AnyObject] else { failure(nil); return }
        self.delegate?.completedRequest(response: data)
    }
    
    private func failure(_ data: Error?) {
        self.delegate?.failedRequest(response: data?.localizedDescription ?? "Unknown response." )
    }
}
