//
//  FeedVC.swift
//  Party Face
//
//  Created by Emerick Asmus on 18/09/17.
//  Copyright © 2017 Emerick Asmus. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func goToProfilePressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Profile") as! UserVC
        self.present(vc, animated: false, completion: nil)
    }
    
    
    @IBAction func usersBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "feedToUsers", sender: nil)
        print("EMERICK: segue pressed")
    }
    
    
}
