//
//  PostTVController.swift
//  Party Face
//
//  Created by Emerick Asmus on 21/09/17.
//  Copyright © 2017 Emerick Asmus. All rights reserved.
//

import UIKit
import Firebase

class PostTVController: UITableViewController {

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

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        loadFeed()
        
    }
    
    func loadFeed() {
        
       
        
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return personArray.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellT", for: indexPath) as! FeedCell

        // Configure the cell...
        self.configureCell(cell: cell, indexPath: indexPath as NSIndexPath, personArray: self.personArray)

        return cell
    }

    private func configureCell(cell: FeedCell, indexPath: NSIndexPath, personArray: [AddPerson]) {


            cell.nameField.text = personArray[indexPath.row].name
            cell.dateField.text = personArray[indexPath.row].date
            cell.locationField.text = personArray[indexPath.row].location


    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Delete the row from the data source
//            personArray.remove(at: indexPath.row)
//            let ref =  personArray[indexPath.row].ref
//            ref?.removeValue()
//
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }

}


