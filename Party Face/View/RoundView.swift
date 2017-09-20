//
//  RoundView.swift
//  Party Face
//
//  Created by Emerick Asmus on 19/09/17.
//  Copyright © 2017 Emerick Asmus. All rights reserved.
//

import UIKit

class RoundView: UIImageView {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.frame.width/2
    }

}
