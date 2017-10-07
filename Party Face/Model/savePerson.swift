//
//  FeedService.swift
//  Party Face
//
//  Created by Emerick Asmus on 23/09/17.
//  Copyright © 2017 Emerick Asmus. All rights reserved.
//

import Foundation
import Firebase

struct Posts {
    
    var username: String!
    var name: String!
    var location: String!
    var date: String!
    var ref: FIRDatabaseReference?
    var key: String!
    var postImageStringUrl: String!
    var userImageStringUrl: String!
    var postId: String!
    
    init(postImageStringUrl: String, userImageStringUrl: String, username: String, name: String, location: String, date: String, key: String = "", postId: String) {
        
        self.username = username
        self.name = name
        self.location = location
        self.date = date
        self.key = key
        self.ref = FIRDatabase.database().reference()
        self.postImageStringUrl = postImageStringUrl
        self.userImageStringUrl = userImageStringUrl
        self.postId = postId
        
    }
    
    init(snapshot: FIRDataSnapshot) {
        
        key = snapshot.key
        ref = snapshot.ref
        let values = snapshot.value as! Dictionary<String,String>
        username = values["username"]
        let values1 = snapshot.value as! Dictionary<String,String>
        name = values1["name"]
        let values2 = snapshot.value as! Dictionary<String,String>
        location = values2["location"]
        let values3 = snapshot.value as! Dictionary<String,String>
        date = values3["date"]
        let values4 = snapshot.value as! Dictionary<String,String>
        postImageStringUrl = values4["postImageStringUrl"]
        let values5 = snapshot.value as! Dictionary<String,String>
        postId = values5["postId"]
        let values6 = snapshot.value as! Dictionary<String,String>
        userImageStringUrl = values6["userImageStringUrl"]
        
    }
    
    func toAny() -> [String: Any] {
        
        return ["username": username, "name": name, "location": location, "date": date, "postImageStringUrl": postImageStringUrl, "postId": postId, "userImageStringUrl": userImageStringUrl]
        
    }
    
}
