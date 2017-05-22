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
    
    // Enum.
    enum ValidationError: Error {
        case mandatory, name, password, passwordLength
    }
    
    // MARK: @IBOutlets.
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var buttonSignUp: UIButton!
    
    // Class instances.
    lazy var registrar: Registrar = {
        let regis = Registrar()
        regis.delegate = self
        return regis
    }()
    
    // Lifecycle Methods.
    override func viewDidLoad() { super.viewDidLoad(); onViewDidLoad() }
    // View Methods.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { super.touchesBegan(touches, with: event); endEditing() }
    
    func onViewDidLoad() {
        buttonSignUp.border(color: .darkGray)
    }
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
    
    @IBAction func buttonSignUpAction(_ sender: UIButton) { endEditing(); initRequest(shouldLogin: false) }
    @IBAction func buttonLoginAction(_ sender: UIButton) { endEditing(); initRequest(shouldLogin: true) }
    
    func initRequest(shouldLogin: Bool) {
        do
        {
            try validate(shouldLogin: shouldLogin)
        }
        catch ValidationError.mandatory {
            dropBanner(withString: "All fields are mandatory.")
        }
        catch ValidationError.name {
            dropBanner(withString: "Username can't be blank.")
        }
        catch ValidationError.password {
            dropBanner(withString: "Password needs to be 6-16 letters long.")
        }
        catch ValidationError.passwordLength {
            dropBanner(withString: "Password needs to be 6-16 letters long.")
        }
        catch {} // Never called.
    }
    
    func validate(shouldLogin: Bool) throws {
        // If either of the fields are empty throw error.
        guard let username = textFieldUsername.text, let password = textFieldPassword.text else { throw ValidationError.mandatory }
        if username.isEmpty { throw ValidationError.name }
        if password.isEmpty { throw ValidationError.password }
        if password.characters.count < 6 || password.characters.count > 16 { throw ValidationError.passwordLength }
        // Login or Register.
        indicator.start(onView: view)
        registrar.send(shouldLogin: shouldLogin, username: username, password: password)
    }
    
    // Upon failing of login or register this delegate is called.
    func failed(withError error: String) {
        indicator.stop()
        dropBanner(withString: error)
    }
}
