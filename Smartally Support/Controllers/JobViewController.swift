//
//  JobViewController.swift
//  Smartally Support
//
//  Created by Muqtadir Ahmed on 19/05/17.
//  Copyright © 2017 Bitjini. All rights reserved.
//

import IQKeyboardManagerSwift
import UIKit

class JobViewController: BaseViewController {
    
    // Enums.
    enum ValidationError: Error {
        case name, amount
    }
    
    // Class Instance.
    lazy var updateJob: UpdateJob = {
       let update = UpdateJob()
        update.delegate = self
        return update
    }()
    
    // Passed parameters.
    var job: Job.Job!
    var decimalCount = 0
    
    // @IBOutlets.
    @IBOutlet weak var tableViewJob: UITableView!

    // Lifecycle methods.
    override func viewDidLoad() { super.viewDidLoad(); onViewDidLoad() }
    
    func onViewDidLoad() {
        guard let updateCell = tableViewJob.dequeueReusableCell(withIdentifier: "UpdateJobTableViewCell") else { return }
        tableViewJob.tableFooterView = updateCell
    }
    
    // @IBAction.
    @IBAction func buttonUpdateAction(_ sender: UIButton) {
        endEditing()
        do
        {
            try validate()
        }
        catch ValidationError.name {
            dropBanner(withString: "Can't update job with blank merchant name.")
        }
        catch ValidationError.amount {
            dropBanner(withString: "Can't update job with blank amount.")
        }
        catch {} // Will never reach.
    }
    
}

extension JobViewController: UpdateJobDelegate {
    
    func validate() throws {
        if job.name.isEmpty   { throw ValidationError.name }
        if job.amount.isEmpty { throw ValidationError.amount }
        
        indicator.start(onView: view)
        updateJob.updateJob(job: job)
    }
    
    func updated() {
        // Remove the updated job, and pop VC.
        for (i, job) in Job.jobs.enumerated() {
            if job == self.job {
                print(job, self.job)
                Job.jobs.remove(at: i)
                indicator.stop()
                navigationController?.popViewController(animated: true)
                break
            }
        }
    }
    
    func failed(withError error: String) {
        dropBanner(withString: error)
    }
}

extension JobViewController: UITableViewDataSource, UITableViewDelegate {
    
    func reload() {
        tableViewJob.reloadData()
    }
    
    // Job Cell.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobTableViewCell") as! JobTableViewCell
        cell.set(job: job)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 410.0
    }
}

extension JobViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            textField.text = ""
            decimalCount = 0
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 1 {
            
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { dropBanner(withString: "Can't leave the field blank."); return }
        if text.isEmpty { dropBanner(withString: "Can't leave the field blank."); return }
        
        if textField.tag == 0 {
            job.name = text
        }
            
        else {
            job.amount = text.to2DecimalPlaces()
        }
        
        reload()
    }
}
