//
//  PasswordVC.swift
//  Party Face
//
//  Created by Emerick Asmus on 19/09/17.
//  Copyright © 2017 Emerick Asmus. All rights reserved.
//

import UIKit

class PasswordVC: UIViewController {

    @IBOutlet weak var passwordBackground: UIView!
    @IBOutlet weak var passwordField: UITextField!
    
    let networkingService = NetworkingService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Add a gradient color to background
        passwordBackground.setGradientBackground(colorOne: Colors.crayn, colorTwo: Colors.softLightBlue)
        passwordBackground.layer.masksToBounds = true
        
    }
    
    @IBAction func resetPasswordPressed(_ sender: Any) {
        networkingService.resertPassword(email: passwordField.text!)
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
