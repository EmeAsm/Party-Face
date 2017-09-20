//
//  UsersVC.swift
//  Party Face
//
//  Created by Emerick Asmus on 20/09/17.
//  Copyright © 2017 Emerick Asmus. All rights reserved.
//

import UIKit

class UsersVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func feedBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "usersToFeed", sender: nil)
    }
    

}
