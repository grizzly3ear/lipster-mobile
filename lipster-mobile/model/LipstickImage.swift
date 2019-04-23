//
//  LipstickImages.swift
//  lipster-mobile
//
//  Created by Mainatvara on 24/4/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class LipstickImage {
    
    var lipstickImageId : Int
    var lipstickImage : UIImage
    
    init(lipstickImageId : Int, lipstickImage : UIImage) {
        self.lipstickImage = lipstickImage
        self.lipstickImageId = lipstickImageId
    }
    
    init(){
        self.lipstickImage = UIImage()
        self.lipstickImageId = Int()
    }
}
