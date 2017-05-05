//
//  CircleView.swift
//  TimSocial
//
//  Created by kinia on 05.05.2017.
//  Copyright © 2017 kinia. All rights reserved.
//

import UIKit

class CircleView: UIImageView {


    override func layoutSubviews() {
        super.layoutSubviews()
       layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }

}
