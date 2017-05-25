//
//  JobView.swift
//  Smartally Support
//
//  Created by Muqtadir Ahmed on 23/05/17.
//  Copyright © 2017 Bitjini. All rights reserved.
//

import UIKit

class JobView: UIView {
    
    // Passed Job Details.
    var job: Job.Job = Job.Job(with: [:]) {
        didSet {
            set()
        }
    }

    // @IBOutlets.
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldAmount: UITextField!
    @IBOutlet weak var textFieldDate: UITextField!
    @IBOutlet weak var textFieldInvoice: UITextField!

    func set() {
        // Set image.
        if let url = job.imageEp {
            imageView.kf.setImage(with: url, placeholder: UIImage(named: "jobs_placeholder"))
        }
        else { imageView.image = UIImage(named: "jobs_placeholder") }
        // Other texts.
        textFieldName.text = job.name
        textFieldAmount.text = job.amount
        textFieldDate.text = job.date?.mediumStyle() ?? ""
        textFieldInvoice.text = job.invoice
    }
    
    func enableTextFields() {
        textFieldName.isUserInteractionEnabled = true
        textFieldAmount.isUserInteractionEnabled = true
        textFieldDate.isUserInteractionEnabled = true
        textFieldInvoice.isUserInteractionEnabled = true
    }
    
    func setDelegate(jobView: EditJobView) {
        textFieldName.delegate = jobView
        textFieldAmount.delegate = jobView
        textFieldInvoice.delegate = jobView
    }
}
