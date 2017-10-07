//
//  UsersTVC.swift
//  Party Face
//
//  Created by Emerick Asmus on 21/09/17.
//  Copyright © 2017 Emerick Asmus. All rights reserved.
//

import UIKit
import Firebase

class UsersTVC: UITableViewController {
    
    var usersArray = [User]()
    
    var databaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    var storageRef: FIRStorage! {
        return FIRStorage.storage()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        loadUsers()
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usersArray.count
    }
    
    func loadUsers() {
        
        let usersRef = databaseRef.child("users")
        usersRef.observe(.value, with: { (snapshot) in
            
            var allUsers = [User]()
            for user in snapshot.children {
                
                let newUser = User(snapshot: user as! FIRDataSnapshot)
                allUsers.append(newUser)
                
            }
            
            self.usersArray = allUsers.sorted(by: { (user1, user2) -> Bool in
                user1.username < user2.username
            })
            
            self.usersArray = allUsers
            self.tableView.reloadData()
            
        }) { (error) in
            print("EMERICK: somthing went wrong loading users")
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "usersCell", for: indexPath) as! UsersCell

        // Configure the cell...
        self.configureCell(cell: cell, indexPath: indexPath as NSIndexPath, userArray: self.usersArray)

        return cell
    }
    
    private func configureCell(cell: UsersCell, indexPath: NSIndexPath, userArray: [User]) {
        
        cell.userNameField.text = usersArray[indexPath.row].username
        storageRef.reference(forURL: usersArray[indexPath.row].photoUrl).data(withMaxSize: 1 * 1024 * 1024) { (imgData, error) in
            if let error = error {
                print("EMERICK: Something went wrong while trying to set users image \(error)")
            } else {
                
                if let data = imgData {
                    cell.usersImg.image = UIImage(data: data)
                }
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    

    @IBAction func goToFeedPressed(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }

}
