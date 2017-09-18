//
//  SignInVC.swift
//  Party Face
//
//  Created by Emerick Asmus on 18/09/17.
//  Copyright © 2017 Emerick Asmus. All rights reserved.
//

import UIKit

class SignInVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var signInBackground: UIView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add a gradient color to background
        signInBackground.setGradientBackground(colorOne: Colors.crayn, colorTwo: Colors.softLightBlue)
        signInBackground.layer.masksToBounds = true
        
        self.emailField.delegate = self
        self.passwordField.delegate = self
        
    }
    
    // Hide keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Hide when return key is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        return (true)
    }


}

