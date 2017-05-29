//
//  LoginRegisterViewController.swift
//  Smartally Support
//
//  Created by Muqtadir Ahmed on 19/05/17.
//  Copyright © 2017 Bitjini. All rights reserved.
//

import IQKeyboardManagerSwift
import UIKit

class LoginRegisterViewController: BaseViewController {
    
    // MARK: @IBOutlets.
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var buttonSignUp: UIButton!
    
    // Lifecycle Methods.
    override func viewDidLoad() { super.viewDidLoad(); onViewDidLoad() }
    // View Methods.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { super.touchesBegan(touches, with: event); endEditing() }
    func onViewDidLoad() { buttonSignUp.border(color: .darkGray) }
}

// MARK: UITextField delegates.
extension LoginRegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let manager = IQKeyboardManager.sharedManager()
        if manager.canGoNext { manager.goNext() }
        else { endEditing() }
        return true
    }
}

// MARK: @IBActions, Login, register flow.
extension LoginRegisterViewController: RegistrarDelegate {
    
    @IBAction func buttonSignUpAction(_ sender: UIButton) { endEditing(); initRequest() }
    @IBAction func buttonLoginAction(_ sender: UIButton) { endEditing(); initRequest(shouldRegister: false) }
    
    func initRequest(shouldRegister: Bool = true) {
        let credential = Registrar.Credential(username: textFieldUsername.text ?? "", password: textFieldPassword.text ?? "")
        do
        {
            try Validator.validate(credential: credential) // Validate.
            indicator.start(onView: view)
            let registrar = Registrar(credential: credential, shouldRegister: shouldRegister)
            registrar.delegate = self
        }
        catch Validator.Err.username {
            dropBanner(withString: "Username can't be blank.")
        }
        catch Validator.Err.password {
            dropBanner(withString: "Password can't be blank.")
        }
        catch Validator.Err.passwordLength {
            dropBanner(withString: "Password needs to be 6-16 letters long.")
        }
        catch {} // Never called.
    }
    
    // Upon failing of login or register this delegate is called.
    func failed(withError error: String) {
        indicator.stop()
        dropBanner(withString: error)
    }
}
