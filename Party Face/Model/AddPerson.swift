//
//  AddPerson.swift
//  Party Face
//
//  Created by Emerick Asmus on 21/09/17.
//  Copyright © 2017 Emerick Asmus. All rights reserved.
//

import Foundation
import Firebase

struct AddPerson {
    
    var username: String!
    var name: String!
    var location: String!
    var date: String!
    var ref: FIRDatabaseReference?
    var key: String!
    
    init(username: String, name: String, location: String, date: String, key: String = "") {
        
        self.username = username
        self.name = name
        self.location = location
        self.date = date
        self.key = key
        self.ref = FIRDatabase.database().reference()
        
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
        
    }
    
    func toAny() -> [String: Any] {
        
        return ["username": username, "name": name, "location": location, "date": date]
        
    }
    
}
