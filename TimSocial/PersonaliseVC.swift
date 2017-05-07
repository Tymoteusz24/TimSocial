//
//  PersonaliseVC.swift
//  TimSocial
//
//  Created by kinia on 05.05.2017.
//  Copyright © 2017 kinia. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class PersonaliseVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imagePicker: UIImagePickerController!
    @IBOutlet weak var userProfileImage: CircleView!
    @IBOutlet weak var userName: FancyField!
    var refUser: FIRDatabaseReference!
    var imageSelected = false
    
    let key = KeychainWrapper.standard.string(forKey: KEY_UID)
    //var user: Users!

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        if Users.us.userName != "" {
            imageSelected = true
            userName.text = Users.us.userName
            if Users.us.userImgUrl != "" {

                    let ref = FIRStorage.storage().reference(forURL: Users.us.userImgUrl)
                    ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                        if error != nil {
                            print("TIMI: Unable to dowload image from storage")
                        } else {
                            print("TIMI: Image downloaded from storage")
                            if let imgData = data {
                                if let imgProfile = UIImage(data: imgData) {
                                    self.userProfileImage.image = imgProfile
                                    FeedVC.imageCache.setObject(imgProfile, forKey: Users.us.userImgUrl as NSString)
                                    
                                }
                            }
                        }
                        
                    })

            }
            
        
        }
        
       // print("PersonalVC-ViewDidAppear: userName: \(Users.us.provider) userUID: \(Users.us.userUid) keyUID:  " + key!)
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
//        if Users.us.userName != "" && Users.us.userImgUrl != "" {
//            performSegue(withIdentifier: "goToFeed", sender: AnyObject.self)
//            
//        }

    }

//    func updateUserProfile() {
//        refUser = DataService.ds.REF_USER_CURRENT.child("userName")
//        guard let userName = userName.text, userName != "" else {
//            print("TIMI: userName must be entered")
//            return
//        }
//        refUser.setValue(userName)
//        
//        
//    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            userProfileImage.image = image
            imageSelected = true
        } else {
            
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    @IBAction func addUserImagePressed(_ sender: Any) {
        present(imagePicker, animated: true, completion:  nil)
    }
    
    @IBAction func donePressed(_ sender: Any) {
        
        guard let userName = userName.text, userName != "" else {
            print("TIMI: caption must be entered")
            return
        }
        guard let img = userProfileImage.image, imageSelected == true else {
            print("TIMI: Img Must be selected")
            return
        }
        
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2) {
        let imgUid = KeychainWrapper.standard.string(forKey: KEY_UID)
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
            DataService.ds.REF_PROFILE_IMAGES.child(imgUid!).put(imgData, metadata: metadata) { ( metadata, error) in
                if error != nil {
                    print("Timi: unable to upload img to storage")
                } else {
                    print("TIMI: Succes upload img to storage")
                    let downloadURL = (metadata?.downloadURL()?.absoluteString)
                    

                    
                    if let url = downloadURL {
                        Users.us.userImgUrl = downloadURL!
                        Users.us.userName = userName
                        
                        
                        let userData = ["userName": userName as String as AnyObject, "profileImgUrl": url as String as AnyObject, "provider": Users.us.provider as String as AnyObject]
                        
                        
                        self.completedSignIn(id: Users.us.userUid, userData: userData as! Dictionary<String, String>)
        
                        
                    }
                    
                    
                }
                
            }
        }
    }
 
//    func updateUserProfile (imageURL: String) {
//        
//        Users.init(userName: userName.text!, userImgUrl: imageURL)
//        
//        let profileData: Dictionary<String, AnyObject> = ["userName": userName.text! as String as AnyObject, "profileImgUrl": imageURL as String as AnyObject, "provider": Users.us.provider as String as AnyObject]
//        
//        let firebaseUserProfile = DataService.ds.REF_USER_CURRENT
//        firebaseUserProfile.setValue(profileData)
//        print("TIMI: send profile data to firebase")
//        performSegue(withIdentifier: "goToFeed", sender: AnyObject.self)
//    }
    
    func completedSignIn(id: String, userData: Dictionary<String, String>) {
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        let keyChainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        self.performSegue(withIdentifier: "goToFeed", sender: AnyObject.self)
        print("Timi- Data saved to keychain \(keyChainResult)")
    }

    
}
