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
    
    let netWorkingService = NetworkingService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add a gradient color to background
        signInBackground.setGradientBackground(colorOne: Colors.crayn, colorTwo: Colors.softLightBlue)
        signInBackground.layer.masksToBounds = true
        
        self.emailField.delegate = self
        self.passwordField.delegate = self
        
    }
    
    // Open Feed from Log In
    override func viewDidAppear(_ animated: Bool) {
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            print("EMERICK: ID found in keychain")
            // Perform segue between SignInVC to FeedVC
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyFeed") as! FeedVC
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    // Open Sign Up From Log In
    @IBAction func signUpBtnPressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Signup") as! SignUpVC
        self.present(vc, animated: true, completion: nil)
    }
    
    // Open Forgot Password From Log In
    @IBAction func forgotPasswordPressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ResetPassword") as! PasswordVC
        self.present(vc, animated: true, completion: nil)
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
                        let userData = ["provider": user.providerID]
                        self.completeSignIn(id: user.uid, userData: userData)
                    }
                } else {
                    print("EMERICK: Something went wrong while trying to log in")
                    let alert = UIAlertController(title: "Log In", message: error!.localizedDescription, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)

                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }) 
        }

    }
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("EMERICK: Data saved to keychain \(keychainResult)")
        // Perform segue between SignInVC to FeedVC
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyFeed") as! FeedVC
        self.present(vc, animated: false, completion: nil)
    }
    
    
}

