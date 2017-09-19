//
//  FancyView.swift
//  Party Face
//
//  Created by Emerick Asmus on 19/09/17.
//  Copyright © 2017 Emerick Asmus. All rights reserved.
//

import UIKit

class FancyView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: shadow_gray, green: shadow_gray, blue: shadow_gray, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.cornerRadius = 2.0
    }
    

}
