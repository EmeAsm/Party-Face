//
//  PasswordVC.swift
//  Party Face
//
//  Created by Emerick Asmus on 19/09/17.
//  Copyright © 2017 Emerick Asmus. All rights reserved.
//

import UIKit

class PasswordVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var passwordBackground: UIView!
    @IBOutlet weak var passwordField: UITextField!
    
    let networkingService = NetworkingService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Add a gradient color to background
        passwordBackground.setGradientBackground(colorOne: Colors.crayn, colorTwo: Colors.softLightBlue)
        passwordBackground.layer.masksToBounds = true
        
        self.passwordField.delegate = self
        
    }
    
    @IBAction func resetPasswordPressed(_ sender: Any) {
        networkingService.resertPassword(email: passwordField.text!)
        
        let alert = UIAlertController(title: "Password", message: "We have sent a password reset email to your email address: \(passwordField.text!)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Hide keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Hide when return key is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        passwordField.resignFirstResponder()
        return (true)
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
