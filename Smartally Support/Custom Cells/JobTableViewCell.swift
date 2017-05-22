//
//  JobTableViewCell.swift
//  Smartally Support
//
//  Created by Muqtadir Ahmed on 20/05/17.
//  Copyright © 2017 Bitjini. All rights reserved.
//

import UIKit

class JobTableViewCell: UITableViewCell {

    // @IBOutlets.
    @IBOutlet weak var imageViewJob: UIImageView!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldAmount: UITextField!
    
    func set(job: Job.Job) {
        textFieldName.text = job.name
        textFieldAmount.text = job.amount
        
        if let url = job.imageEp {
            imageViewJob.kf.setImage(with: url, placeholder: UIImage(named: "jobs_placeholder"))
            return
        }
        imageViewJob.image = UIImage(named: "jobs_placeholder")
    }
}
