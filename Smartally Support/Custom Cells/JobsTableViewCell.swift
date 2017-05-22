//
//  JobsTableViewCell.swift
//  Smartally Support
//
//  Created by Muqtadir Ahmed on 20/05/17.
//  Copyright © 2017 Bitjini. All rights reserved.
//

import UIKit

class JobsTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewJob: UIImageView!
    
    func set(withUrl url: URL?) {
        if let url = url {
            imageViewJob.kf.setImage(with: url, placeholder: UIImage(named: "jobs_placeholder"))
            return
        }
        imageViewJob.image = UIImage(named: "jobs_placeholder")
    }
}
