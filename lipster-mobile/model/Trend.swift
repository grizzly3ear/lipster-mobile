//
//  Trends.swift
//  lipster-mobile
//
//  Created by Mainatvara on 21/4/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//
import Foundation
import UIKit

class Trend {
    
    var trendImage : String
    var trendLipstickColor : UIColor
    var trendSkinColor : UIColor
    var trendDescription: String
    
    init(trendImage: String,  trendLipstickColor: UIColor, trendSkinColor: UIColor, trendDescription: String) {
        self.trendImage = trendImage
        self.trendLipstickColor = trendLipstickColor
        self.trendSkinColor = trendSkinColor
        self.trendDescription = trendDescription   
    }
}
