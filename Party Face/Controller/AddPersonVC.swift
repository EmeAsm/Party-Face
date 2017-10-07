//
//  AddPersonVC.swift
//  Party Face
//
//  Created by Emerick Asmus on 21/09/17.
//  Copyright © 2017 Emerick Asmus. All rights reserved.
//

import UIKit
import Firebase

class AddPersonVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var addPersonBackground: UIView!
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    
    // Date picker
    let datePicker = UIDatePicker()
    
    // Image picker
    var imagePicker: UIImagePickerController!
    
    var databaseRef: FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
    
    var storageRef: FIRStorageReference! {
        return FIRStorage.storage().reference()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Add a gradient color to background
        addPersonBackground.setGradientBackground(colorOne: Colors.crayn, colorTwo: Colors.softLightBlue)
        addPersonBackground.layer.masksToBounds = true
        
        self.thumbImg.layer.cornerRadius = self.thumbImg.frame.size.width / 2
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        // Set date
        createDatePicker()
        
        // Return keyboard
        self.nameField.delegate = self
        self.locationField.delegate = self
        self.dateField.delegate = self
        
    }
    
    // Hide keyboard when user touches outside keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Hide when return key is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameField.resignFirstResponder()
        locationField.resignFirstResponder()
        return (true)
    }
    
    func createDatePicker() {
        
        // Format picker
        datePicker.datePickerMode = .date
        
        // Toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // Bar button item
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed) )
        toolbar.setItems([doneButton], animated: false)
        
        dateField.inputAccessoryView = toolbar
        
        // Assign date picker to text field
        dateField.inputView = datePicker
        
    }
    
    @objc func donePressed() {
        
        // Format date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        dateField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
        
    }
    
    // Add image form Library
    @IBAction func addImage(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    // Take a picture with the camera and save it
    @IBAction func takeImage(_ sender: UIButton) {
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.sourceType = .camera
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            thumbImg.image = img
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        picker.dismiss(animated: true, completion: nil)
        
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePerson(_ sender: Any) {
            
//        // Create Person reference in Firebase
//        let addPersonRef = databaseRef.child("posts").childByAutoId()
//
//        let person = AddPerson(username: (FIRAuth.auth()?.currentUser!.displayName)!, name: nameField.text!, location: locationField.text!, date: dateField.text!)
//
//        addPersonRef.setValue(person.toAny())
        
        let data = UIImageJPEGRepresentation(self.thumbImg.image!, 0.5)
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let postId = "\(FIRAuth.auth()!.currentUser?.uid ?? "post")\(NSUUID().uuidString)"
        let imagePath = "postImage\(postId)/postPic.jpg"
        
        storageRef.child(imagePath).put(data!, metadata: metadata) { (metadata, error) in
            if error == nil {
                
                let postRef = self.databaseRef.child("posts").childByAutoId()
                let post = Posts(postImageStringUrl: String(describing: metadata!.downloadURL()!), userImageStringUrl: String(describing: FIRAuth.auth()!.currentUser?.photoURL!), username: (FIRAuth.auth()?.currentUser!.displayName)!, name: self.nameField.text!, location: self.locationField.text!, date: self.dateField.text!, postId: postId)
                
                postRef.setValue(post.toAny())
                
            } else {
                print(error!.localizedDescription)
            }
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
}
