//
//  FeedCellTableViewCell.swift
//  TimSocial
//
//  Created by kinia on 05.05.2017.
//  Copyright © 2017 kinia. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileLbl: UILabel!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var feedImage: UIImageView!
    @IBOutlet weak var feedText: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var numberLikesLbl: UILabel!
   // @IBOutlet weak var caption: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell() {
        
    }


}
