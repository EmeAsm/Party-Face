//
//  UsersVC.swift
//  Party Face
//
//  Created by Emerick Asmus on 20/09/17.
//  Copyright © 2017 Emerick Asmus. All rights reserved.
//

import UIKit
import Firebase

class UsersVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    @IBOutlet weak var tableView: UITableView!
    
    var usersArray = [User]()
    
    var databaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    var storageRef: FIRStorage! {
        return FIRStorage.storage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        loadUsers()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "usersCellVC", for: indexPath) as! UsersCell
        
        // Configure the cell...
        self.configureCell(cell: cell, indexPath: indexPath as NSIndexPath, userArray: self.usersArray)
        
        return cell
    }
    
    private func configureCell(cell: UsersCell, indexPath: NSIndexPath, userArray: [User]) {
        print(usersArray[indexPath.row].username)
        DispatchQueue.main.async {
            cell.userNameField.text = self.usersArray[indexPath.row].username
            print("EMERICK: Everything ok")
        }
        storageRef.reference(forURL: usersArray[indexPath.row].photoUrl).data(withMaxSize: 1 * 1024 * 1024) { (imgData, error) in
            if let error = error {
                print("EMERICK: Something went wrong while trying to set users image \(error)")
            } else {
                
                DispatchQueue.main.async {
                    if let data = imgData {
                        cell.usersImg.image = UIImage(data: data)
                    }
                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }


    @IBAction func goToFeedPressed(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func addPersonPressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddPerson") as! AddPersonVC
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func goToProfilePressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Profile") as! UserVC
        self.present(vc, animated: false, completion: nil)
    }

}
