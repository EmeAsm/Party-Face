//
//  User.swift
//  Party Face
//
//  Created by Emerick Asmus on 20/09/17.
//  Copyright © 2017 Emerick Asmus. All rights reserved.
//

import Foundation
import Firebase

struct User {
    
    var username: String!
    var email: String!
    var photoUrl: String!
    var uid: String!
    var ref: FIRDatabaseReference?
    var key: String?
    
    init(snapshot: FIRDataSnapshot) {
        
        key = snapshot.key
        ref = snapshot.ref
        let values = snapshot.value as! Dictionary<String,String>
        username = values["username"]
        let values1 = snapshot.value as! Dictionary<String,String>
        photoUrl = values1["photoUrl"]
        let values2 = snapshot.value as! Dictionary<String,String>
        email = values2["email"]
        
        
    }
    
    init(username: String, userId: String, photoUrl: String) {
        self.username = username
        self.uid = userId
        self.photoUrl = photoUrl
    }
    
}
