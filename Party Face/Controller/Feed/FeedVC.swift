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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var personArray = [AddPerson]()
    var postsArray = [Posts]()
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

        loadFeed()
        
    }
    
    func loadFeed() {
        
        if FIRAuth.auth()?.currentUser == nil {
            print("EMERICK: Somthing went wrong while trying to show profile information")
        } else {
        
        let postsRef = databaseRef.child("posts")
        postsRef.observe(.value, with: { (snapshot) in
            
            var newItem = [Posts]()
            
            for item in snapshot.children {
                let newPerson = Posts(snapshot: item as! FIRDataSnapshot)
                newItem.append(newPerson)
            }
            
            print("EMERICK: Data tranfered to tableview")
            
            self.postsArray = newItem
            self.tableView.reloadData()
            
        }) { (error) in
            print(error.localizedDescription)
        }
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return postsArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedCell
        
        // Configure the cell...
        self.configureCell(cell: cell, indexPath: indexPath as NSIndexPath, personArray: self.postsArray)
        
        return cell
    }
    
    func configureCell(cell: FeedCell, indexPath: NSIndexPath, personArray: [Posts]) {
        
        
        cell.nameField.text = personArray[indexPath.row].name
        cell.dateField.text = personArray[indexPath.row].date
        cell.locationField.text = personArray[indexPath.row].location

        storageRef.reference(forURL: postsArray[indexPath.row].postImageStringUrl).data(withMaxSize: 1 * 1024 * 1024) { (imgData, error) in
            if let error = error {
                print("EMERICK: Something went wrong while trying to set post image \(error)")
            } else {

                DispatchQueue.main.async {
                    if let data = imgData {
                        cell.thumbImg.image = UIImage(data: data)
                    }
                }
            }
        }
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 340
    }
    
    @IBAction func goToProfilePressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Profile") as! UserVC
        self.present(vc, animated: false, completion: nil)
    }

    @IBAction func usersPressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UsersVC") as! UsersVC
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func addPersonPressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddPerson") as! AddPersonVC
        self.present(vc, animated: true, completion: nil)
    }
    
}
