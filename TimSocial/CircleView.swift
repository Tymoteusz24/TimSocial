//
//  CircleView.swift
//  TimSocial
//
//  Created by kinia on 05.05.2017.
//  Copyright © 2017 kinia. All rights reserved.
//

import UIKit

class CircleView: UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
       layer.cornerRadius = self.frame.width / 2
    }

}
