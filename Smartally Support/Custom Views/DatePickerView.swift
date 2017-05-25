//
//  DatePickerView.swift
//  Reimber
//
//  Created by Muqtadir Ahmed on 20/03/17.
//  Copyright © 2017 Bitjini. All rights reserved.
//

import UIKit

protocol DatePickerDelegate {
    func selectedDate(_ date: Date)
}

class DatePickerView: UIView {

    var delegate: DatePickerDelegate?
    
    // MARK: @IBOutlet.
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        datePicker.date = Date()
        datePicker.maximumDate = Date()
    }
    
    @IBAction func selectedDateAction(_ sender: UIButton) {
        delegate?.selectedDate(datePicker.date)
        removeFromSuperview()
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        removeFromSuperview()
    }
}
