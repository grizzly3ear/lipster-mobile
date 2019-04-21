//
//  Trends.swift
//  lipster-mobile
//
//  Created by Mainatvara on 21/4/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import Foundation
import UIKit

class Trends {
    
    var trendImage : UIImage
    var trendName : String
    var trendLipstickColor : UIColor
    var trendSkinColor : UIColor
    
    init(trendImage : UIImage ,  trendName : String , trendLipstickColor : UIColor, trendSkinColor : UIColor) {
        self.trendImage = trendImage
        self.trendName = trendName
        self.trendLipstickColor = trendLipstickColor
        self.trendSkinColor = trendSkinColor
        
    }
}
