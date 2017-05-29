//
//  JobView.swift
//  Smartally Support
//
//  Created by Muqtadir Ahmed on 23/05/17.
//  Copyright © 2017 Bitjini. All rights reserved.
//

import IQKeyboardManagerSwift
import UIKit

protocol JobViewDelegate {
    func dropBanner(withString message: String)
}

class JobView: UIView {
    
    fileprivate var decimalCount: Int = 0
    var delegate: JobViewDelegate?
    
    // Class Instances.
    lazy var datePicker: DatePickerView = {
        let view = Bundle.main.loadNibNamed("DatePickerView", owner: nil, options: nil)?.first as! DatePickerView
        view.frame = self.bounds
        view.delegate = self
        return view
    }()

    // @IBOutlets.
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldAmount: UITextField!
    @IBOutlet weak var textFieldDate: UITextField!
    @IBOutlet weak var textFieldInvoice: UITextField!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { super.touchesBegan(touches, with: event); endEditing(true) }

    func set() {
        let job = Job.jobs[tag]
        print(job.imageEp?.absoluteString ?? "No ep.", "Image EP")
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
    
    @IBAction func showDatePicker(_ sender: UIButton) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.endEditing(true)
            self.addSubview(self.datePicker)
        }
    }
}

extension JobView: DatePickerDelegate {
    func selectedDate(_ date: Date) {
        Job.jobs[tag].date = date
        set()
    }
}

extension JobView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0:
            textField.autocapitalizationType = .words
            
        case 1:
            decimalCount = 0
        
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let manager = IQKeyboardManager.sharedManager()
        if manager.canGoNext { manager.goNext() }
        else { endEditing(true) }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { delegate?.dropBanner(withString: "Please fill out all fields."); return }
        switch textField.tag {
        case 0:
            if text.isEmpty { delegate?.dropBanner(withString: "Merchant name can't be blank."); break }
            Job.jobs[tag].name = text
            
        case 1:
            let text = textField.text ?? ""
            if text.isEmpty { delegate?.dropBanner(withString: "Amount can't be blank."); break }
            Job.jobs[tag].amount = text.to2DecimalPlaces()
            
        case 2:
            Job.jobs[tag].invoice = text
            
        default:
            break
        }
    }
    
    // .2 places decimal logic.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 1 {
            if string == "." && (textField.text ?? "").contains(".") { return false }
            if string == "." { return reachedDecimal(range) }
            else if decimalCount > 0 { return afterDecimal(range) }
        }
        
        return true
    }
    
    // Algorithm for %.2f decimal places
    func reachedDecimal(_ range: NSRange) -> Bool {
        decimalCount = range.length == 0 ? decimalCount + 1 : 0
        return true
    }
    
    func afterDecimal(_ range: NSRange) -> Bool {
        if range.length == 0 {
            if decimalCount < 3 {
                decimalCount += 1
                return true
            }
            return false
        }
        decimalCount -= 1
        return true
    }
}
