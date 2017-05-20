//
//  LoginRegisterViewController.swift
//  Smartally Support
//
//  Created by Muqtadir Ahmed on 19/05/17.
//  Copyright © 2017 Bitjini. All rights reserved.
//

import UIKit

class LoginRegisterViewController: BaseViewController {
    
    // Enum.
    enum ValidationError: Error {
        case mandatory
        case password
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
    
    func onViewDidLoad() {
        buttonSignUp.border(color: .darkGray)
    }
    
    // Error to User interface.
    func dropBanner(withString message: String) {
        let banner = ILBanner(title: "Error Occurred",
                              subtitle: message, image: nil,
                              backgroundColor: .white)
        banner.dismissesOnTap = true
        banner.dismissesOnSwipe = true
        banner.show(view, duration: 3.0)
    }
}

// MARK: @IBActions.
extension LoginRegisterViewController: RegistrarDelegate {
    
    @IBAction func buttonSignUpAction(_ sender: UIButton) { initRequest(shouldLogin: false) }
    @IBAction func buttonLoginAction(_ sender: UIButton) { initRequest(shouldLogin: true) }
    
    func initRequest(shouldLogin: Bool) {
        do
        {
            try validate(shouldLogin: shouldLogin)
        }
        catch ValidationError.mandatory {
            dropBanner(withString: "All fields are mandatory.")
        }
        catch ValidationError.password {
            dropBanner(withString: "Password needs to be 6-16 letters long.")
        }
        catch {} // Never called.
    }
    
    func validate(shouldLogin: Bool) throws {
        // If either of the fields are empty throw error.
        guard let username = textFieldUsername.text, let password = textFieldPassword.text else { throw ValidationError.mandatory }
        // If password isn't 6-16 in length.
        if password.characters.count < 6 || password.characters.count > 16 { throw ValidationError.password }
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
