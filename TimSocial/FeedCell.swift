//
//  FeedCellTableViewCell.swift
//  TimSocial
//
//  Created by kinia on 05.05.2017.
//  Copyright © 2017 kinia. All rights reserved.
//

import UIKit
import Firebase

class FeedCell: UITableViewCell {

    @IBOutlet weak var likeImg: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileLbl: UILabel!
    @IBOutlet weak var feedImage: UIImageView!
    @IBOutlet weak var feedText: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var numberLikesLbl: UILabel!
   // @IBOutlet weak var caption: UITextField!
    
    var likeRef: FIRDatabaseReference!
    

    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
                let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likeImg.addGestureRecognizer(tap)
        likeImg.isUserInteractionEnabled = true
        
    }
    
    func configureCell(post: Post, img: UIImage? = nil, imgProfile: UIImage? = nil) {
        self.post = post
        self.feedText.text = post.caption
        self.likesLbl.text = "\(post.likes)"
        self.profileLbl.text = post.userName
        if imgProfile != nil {
            self.profileImage.image = imgProfile
        } else {
            let ref = FIRStorage.storage().reference(forURL: post.profileImg)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil {
                    print("TIMI: Unable to dowload image from storage")
                } else {
                    print("TIMI: Image downloaded from storage")
                    if let imgData = data {
                        if let imgProfile = UIImage(data: imgData) {
                            self.profileImage.image = imgProfile
                            FeedVC.imageCache.setObject(imgProfile, forKey: post.profileImg as NSString)
                    
                        }
                    }
                }
                
            })
            //self.profileImage =
        }
         likeRef = DataService.ds.REF_USER_CURRENT.child("likes").child(post.postKey)
        if img != nil {
            
            self.feedImage.image = img
        } else {

                let ref = FIRStorage.storage().reference(forURL: post.imgUrl)
                ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
                    if error != nil {
                        print("TIMI: Unable to dowload image from storage")
                    } else {
                        print("TIMI: Image downloaded from storage")
                        if let imgData = data {
                            if let img = UIImage(data: imgData) {
                                self.feedImage.image = img
                                FeedVC.imageCache.setObject(img, forKey: post.imgUrl as NSString)
                            }
                        }
                    }
                
                })
            }
        likeRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "empty-heart")
            } else {
                self.likeImg.image = UIImage(named: "filled-heart")
            }
        })
        
    }
    
    func likeTapped(sender: UITapGestureRecognizer) {
        
        likeRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.likeImg.image = UIImage(named: "empty-heart")
                self.post.adjustLikes(addLike: true)
                self.likeRef.setValue(true)
            } else {
                self.likeImg.image = UIImage(named: "filled-heart")
                self.post.adjustLikes(addLike: false)
                self.likeRef.removeValue()
            }
        })
    }

}
