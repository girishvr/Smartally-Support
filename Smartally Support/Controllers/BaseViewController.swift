//
//  BaseViewController.swift
//  Smartally Support
//
//  Created by Muqtadir Ahmed on 19/05/17.
//  Copyright © 2017 Bitjini. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    // Class Instances.
    // Indicator.
    lazy var indicator: ILIndicator = ILIndicator()

    override func viewDidLoad() { super.viewDidLoad() }
    
    // End editing.
    func endEditing() {
        view.endEditing(true)
    }
    
    // Error to User interface.
    func dropBanner(withString message: String) {
        let banner = ILBanner(title: "Error Occurred",
                              subtitle: message, image: nil,
                              backgroundColor: .white)
        banner.titleLabel.textColor = .darkGray
        banner.detailLabel.textColor = .darkGray
        banner.dismissesOnTap = true
        banner.dismissesOnSwipe = true
        banner.show(navigationController?.view ?? view, duration: 3.0)
    }
}


