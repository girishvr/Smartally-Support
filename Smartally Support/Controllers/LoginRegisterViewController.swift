//
//  LoginRegisterViewController.swift
//  Smartally Support
//
//  Created by Muqtadir Ahmed on 19/05/17.
//  Copyright © 2017 Bitjini. All rights reserved.
//

import UIKit

class LoginRegisterViewController: BaseViewController {
    
    // MARK: @IBOutlets.
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!

    override func viewDidLoad() { super.viewDidLoad() }

    func onViewDidLoad() {
        
    }
}

// MARK: @IBActions.
extension LoginRegisterViewController {
    
    @IBAction func buttonSignUpAction(_ sender: UIButton) {
        
    }
    
    @IBAction func buttonLoginAction(_ sender: UIButton) {
        
    }
}

extension LoginRegisterViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}
