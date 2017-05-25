//
//  EditJobView.swift
//  Smartally Support
//
//  Created by Muqtadir Ahmed on 24/05/17.
//  Copyright © 2017 Bitjini. All rights reserved.
//

import UIKit

protocol EditDelegate {
    func update(job: Job.Job)
    func cancelled()
}

class EditJobView: UIView {
    
    // Parameters.
    var job: Job.Job
    var decimalCount: Int
    var delegate: EditDelegate?
    
    // Class Instances.
    lazy var datePicker: DatePickerView = {
        let view = Bundle.main.loadNibNamed("DatePickerView", owner: nil, options: nil)?.first as! DatePickerView
        view.frame = self.bounds
        view.delegate = self
        return view
    }()
    
    lazy var viewJob: JobView = {
        let view = Bundle.main.loadNibNamed("JobView", owner: self, options: nil)?.first as! JobView
        view.frame = CGRect(origin: self.frame.origin, size: CGSize(width: self.frame.size.width, height: self.frame.size.height - 50.0))
        view.imageView.contentMode = .scaleAspectFit
        view.job = self.job
        view.enableTextFields()
        view.setDelegate(jobView: self)
        return view
    }()

    // Init.
    required init?(coder aDecoder: NSCoder) { fatalError("Bleh! I will not implement the coder.") }
    init(frame: CGRect, job: Job.Job) {
        self.job = job
        self.decimalCount = 0
        super.init(frame: frame)
        self.viewPreferences()
    }

    func viewPreferences() {
        // Add the job view.
        addSubview(viewJob)
        // Place buttons.
        let update = UIButton(frame: CGRect(x: 0.0, y: Constants.height - 50.0, width: Constants.width / 2.0, height: 50.0))
        update.setTitle("UPDATE", for: .normal)
        update.setTitleColor(.darkGray, for: .normal)
        update.addTarget(self, action: #selector(EditJobView.update), for: .touchUpInside)
        addSubview(update)
        
        let cancel = UIButton(frame: CGRect(x: Constants.width / 2.0, y: Constants.height - 50.0, width: Constants.width / 2.0, height: 50.0))
        cancel.setTitle("CANCEL", for: .normal)
        cancel.setTitleColor(.darkGray, for: .normal)
        cancel.addTarget(self, action: #selector(EditJobView.cancel), for: .touchUpInside)
        addSubview(cancel)
        
        // Textfield did start editing action.
        viewJob.textFieldDate.addTarget(self, action: #selector(showDatePicker(_:)), for: .editingDidBegin)
    }
    
    func error(withString message: String) {
        let banner = ILBanner(title: "Error Occurred", subtitle: message, image: nil, backgroundColor: .white)
        banner.titleLabel.textColor = .darkGray
        banner.detailLabel.textColor = .darkGray
        banner.dismissesOnTap = true
        banner.dismissesOnSwipe = true
        banner.show(self, duration: 3.0)
    }
    
    func showDatePicker(_ textField: UITextField) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.endEditing(true)
            self.addSubview(self.datePicker)
        }
    }
}

extension EditJobView {
    
    @objc fileprivate func update() {
        do
        {
            try Validator.validate(job: self.job)
            delegate?.update(job: self.job)
            removeFromSuperview()
        }
        catch Validator.Err.name {
            error(withString: "Can't update job with blank merchant name.")
        }
        catch Validator.Err.amount {
            error(withString: "Can't update job with blank amount.")
        }
        catch {} // Will never reach.
    }
    
    @objc fileprivate func cancel() {
        delegate?.cancelled()
        removeFromSuperview()
    }
}

extension EditJobView: DatePickerDelegate {
    func selectedDate(_ date: Date) {
        job.date = date
        viewJob.job = job
    }
}

extension EditJobView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == viewJob.textFieldAmount {
            textField.text = ""
            decimalCount = 0
            return
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case viewJob.textFieldName:
            let text = textField.text ?? ""
            if text.isEmpty { error(withString: "Merchant name can't be blank."); break }
            job.name = text
            
        case viewJob.textFieldAmount:
            let text = textField.text ?? ""
            if text.isEmpty { error(withString: "Amount can't be blank."); break }
            job.amount = text
            
        case viewJob.textFieldInvoice:
            job.invoice = textField.text ?? ""
            
        default:
            break
        }
    }
    
    // .2 places decimal logic.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == viewJob.textFieldAmount {
            
            if string == "." && (textField.text ?? "").contains(".") { return false }
            
            if string == "." {
                return reachedDecimal(range)
            }
            else if decimalCount > 0 {
                return afterDecimal(range)
            }
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
