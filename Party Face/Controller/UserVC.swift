//
//  UserVC.swift
//  Party Face
//
//  Created by Emerick Asmus on 19/09/17.
//  Copyright © 2017 Emerick Asmus. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class UserVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    let picker = UIImagePickerController()
    var databaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    var storageRef: FIRStorage! {
        return FIRStorage.storage()
    }
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Pick profile picture from photo library
        picker.delegate = self
        
        // Shows profile information
        let userID : String = (FIRAuth.auth()?.currentUser?.uid)!
        print("EMERICK: Current user ID is " + userID)
        if FIRAuth.auth()?.currentUser == nil {
            print("EMERICK: Somthing went wron while trying to show profile information")
        } else {
            databaseRef.child("users/\(FIRAuth.auth()!.currentUser!.uid)").observe(.value, with: { (snapshot) in
                DispatchQueue.main.async {
                    
                    let user = User(snapshot: snapshot)
                    self.usernameField.text = user.username
                    self.emailField.text = user.email
                    
                    let imageUrl = String(user.photoUrl)
                    
                    self.storageRef.reference(forURL: imageUrl).data(withMaxSize: 1 * 1024 * 1024, completion: { (data, error) in
                        
                        if let error = error {
                            print(error.localizedDescription)
                        } else {
                            if let data = data {
                                self.imageView.image = UIImage(data: data)
                            }
                        }
                        
                    })
                    
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        
    }

    // Sign out and go back to Sign in screen without returning to feed
    @IBAction func signOutTapped(_ sender: Any) {
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("EMERICK: Id removed from keychain \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! SignInVC
        self.present(vc, animated: false, completion: nil)
        
        
    }
    
    @IBAction func homeBtnPressed(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    
    // Pick profile picture from photo library
    @IBAction func selectImgPressed(_ sender: Any) {
        
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imageView.image = image
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
 
    
}
