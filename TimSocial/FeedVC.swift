//
//  FeedVC.swift
//  TimSocial
//
//  Created by kinia on 05.05.2017.
//  Copyright © 2017 kinia. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageAdd: CircleView!
    @IBOutlet weak var captionField: FancyField!
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var imageSelected = false
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        print("PersonalVC-ViewDidAppear: userName: \(Users.us.userName) userUID: \(Users.us.userUid)")
        uploadUsers()
        
        //sparawdza wszyskie zmiany w tabeli ponizej POSTS
        DataService.ds.REF_POSTS.observe(.value, with: {(snapshot) in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot] {
                self.posts.removeAll()
                for snap in snapshots {
                    print("snap: \(snap) ")
                    if let postDict = snap.value as? Dictionary<String, AnyObject> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                    
                }
            }
           self.tableView.reloadData()
        })
        

        // Do any additional setup after loading the view.
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell") as? FeedCell {
            let post = posts[indexPath.row]
            
            if let img = FeedVC.imageCache.object(forKey: post.imgUrl as NSString), let imgProfile = FeedVC.imageCache.object(forKey: post.profileImg as NSString) {
                cell.configureCell(post: post, img: img, imgProfile: imgProfile )
                return cell
            } else {
              cell.configureCell(post: post)
                return cell
            }
            
        } else {
            return FeedCell()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageAdd.image = image
            imageSelected = true
        } else {
            print("TIMI: Image wasn't selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postButtonPressed(_ sender: Any) {
        guard let caption = captionField.text, caption != "" else {
            print("TIMI: caption must be entered")
            return
        }
        guard let img = imageAdd.image, imageSelected == true else {
            print("TIMI: Img Must be selected")
            return
        }
        if let imgData = UIImageJPEGRepresentation(img, 0.2){
            
            let imgUid = NSUUID().uuidString
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            DataService.ds.REF_POST_IMAGES.child(imgUid).put(imgData, metadata: metadata) { ( metadata, error) in
                if error != nil {
                    print("Timi: unable to upload img to storage")
                } else {
                    print("TIMI: Succes upload img to storage")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    if let url = downloadURL {
                        self.postToFirebase(imageUrl: url)
                    }
                    
                }
            
            }
            
        }
    }
    
    func postToFirebase (imageUrl: String) {
        let post: Dictionary<String, AnyObject> = ["caption" : captionField.text! as String as AnyObject, "imageUrl" : imageUrl as String as AnyObject, "likes" : 0 as AnyObject,
                                                   "profileImgUrl" : Users.us.userImgUrl as String as AnyObject, "userName" : Users.us.userName as String as AnyObject]
        
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
        firebasePost.setValue(post)
        
        captionField.text = ""
        imageSelected = false
        imageAdd.image = UIImage(named: "add-image")
        //tableView.reloadData()
        
        // dodaj dodawanie do bazy img url usera
    }
    
    func uploadUsers() {
        
        let userID = KeychainWrapper.standard.string(forKey: KEY_UID)
        
        let refUser = DataService.ds.REF_USER_CURRENT
        
        refUser.observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? Dictionary<String, AnyObject>
            print("TIMI-SNAPSHOT: \(snapshot)")
            Users.us.updateUser(userKey: userID!, postData: value!)
            
            
            
            print("UserName:\(Users.us.userName) of user Uid: \(Users.us.userUid)")
            
        }) { ( error ) in
            print(error.localizedDescription)
        }
    }
    

    
    @IBAction func addImagePressed(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func signOutPress(_ sender: Any) {
        let keyChainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("TIMI: ID removed from keychain \(keyChainResult)")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "signOut", sender: nil)
    }

    @IBAction func profilepressed(_ sender: Any) {
        performSegue(withIdentifier: "goToProfile", sender: AnyObject.self)
        
    }
}
