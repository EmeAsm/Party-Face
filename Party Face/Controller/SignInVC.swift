//
//  SignInVC.swift
//  Party Face
//
//  Created by Emerick Asmus on 18/09/17.
//  Copyright © 2017 Emerick Asmus. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class SignInVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var signInBackground: UIView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordError: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add a gradient color to background
        signInBackground.setGradientBackground(colorOne: Colors.crayn, colorTwo: Colors.softLightBlue)
        signInBackground.layer.masksToBounds = true
        
        self.emailField.delegate = self
        self.passwordField.delegate = self
        
    }
    
    // Open Feed from Sign In
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            print("EMERICK: ID found in keychain")
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
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

    // Sign user in with email
    @IBAction func signInPressed(_ sender: Any) {
        
        if let email = emailField.text, let pwd = passwordField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print("EMERICK: Email user authenticated with Firebase")
                    if let user = user {
                        self.completeSignIn(id: user.uid)
                    }
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                            print("EMERICK: Unable to authenticate with Firebase using email")
                            self.passwordError.isHidden = false
                        } else {
                            print("EMERICK: Successfully authenticated with Firebase")
                            self.passwordError.isHidden = true
                            if let user = user {
                                self.completeSignIn(id: user.uid)
                            }
                        }
                    })
                }
            })
        }
        
    }
    
    func completeSignIn(id: String) {
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("EMERICK: Data saved to keychain \(keychainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
    }
    
}

