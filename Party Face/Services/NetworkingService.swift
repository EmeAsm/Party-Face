//
//  NetworkingService.swift
//  Party Face
//
//  Created by Emerick Asmus on 19/09/17.
//  Copyright © 2017 Emerick Asmus. All rights reserved.
//

import Foundation
import Firebase

struct NetworkingService {
    
    var databaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    var storageRef: FIRStorageReference {
        return FIRStorage.storage().reference()
    }
    
    
    // Saving the user info in the database
    private func saveInfo(user: FIRUser!, username: String, password: String) {
        
        // Create our user dictionary info
        let userInfo = ["email": user.email!, "username": username, "uid": user.uid, "photoUrl": String(describing: user.photoURL!)]

        // Create user reference
        let userRef = databaseRef.child("users").child(user.uid)
        
        // Save user info in Database
        userRef.setValue(userInfo)
        
        signIn(email: user.email!, password: password)
    }
    
    // Sign in user
    func signIn(email: String, password: String) {
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error == nil {
                if let user = user {
                    print("\(user.displayName!) has signed in succesfully")
                }
            } else {
                print("Emerick: Could'n log in user")
            }
        })
        
    }
    
    // Set User info
    private func setUserInfo(user: FIRUser!, username: String, password: String, data: NSData!) {
        
        // Create Path for the user image
        let imagePath = "profileImage\(user.uid)/userPic.jpg"
        
        // Create image referance
        let imageRef = storageRef.child(imagePath)
        
        // Create metadata for the image
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpeg"
        
        // Save the user image in the Firebase storage file
        imageRef.put(data as Data, metadata: metaData) { (metaData, error) in
            if error == nil {
                
                let changeRequest = user.profileChangeRequest()
                changeRequest.displayName = username
                changeRequest.photoURL = metaData!.downloadURL()
                changeRequest.commitChanges(completion: { (error) in
                    if error == nil {
                        self.saveInfo(user: user, username: username, password: password)
                    } else {
                        print(error!.localizedDescription)
                    }
                })
                
            } else {
                print(error!.localizedDescription)
            }
        }
        
    }
    
    // Reset password
    func resertPassword(email: String) {
        FIRAuth.auth()?.sendPasswordReset(withEmail: email, completion: { (error) in
            if error == nil {
                print("An email with information on how to reset your password has been send to you.")
            } else {
                print("EMERICK: Something went wrong while trying to resset the password")
            }
        })
    }
    
    // We create the user
    func signUp(email: String, username: String, password: String, data: NSData!) {
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error == nil {
                self.setUserInfo(user: user, username: username, password: password, data: data)
            } else {
                print(error!.localizedDescription)
            }
        })
        
    }
    
}
