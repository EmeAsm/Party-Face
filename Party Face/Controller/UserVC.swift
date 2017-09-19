//
//  UserVC.swift
//  Party Face
//
//  Created by Emerick Asmus on 19/09/17.
//  Copyright © 2017 Emerick Asmus. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class UserVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // Sign out and go back to Sign in screen without returning to feed
    @IBAction func signOutTapped(_ sender: Any) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("EMERICK: Id removed from keychain \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
    
    @IBAction func homeBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "userToFeed", sender: nil)
    }
    
    
}
