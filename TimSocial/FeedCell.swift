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

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileLbl: UILabel!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var feedImage: UIImageView!
    @IBOutlet weak var feedText: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var numberLikesLbl: UILabel!
   // @IBOutlet weak var caption: UITextField!
    
    var post: Post!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(post: Post, img: UIImage? = nil) {
        self.post = post
        self.feedText.text = post.caption
        self.likesLbl.text = "\(post.likes)"
        
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

        
    }
    


}
