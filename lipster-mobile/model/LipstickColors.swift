//
//  LipstickColors.swift
//  lipster-mobile
//
//  Created by Mainatvara on 24/4/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class LipstickColors {
    
    var lipstickColorId : String
    var lipstickColorName : String
    var lipstickRGB : UIColor
    var lipstickColorCode : String
    var lipstickImageList : [LipstickImages]?
    
    init(lipstickColorId : String , lipstickColorName : String , lipstickRGB : UIColor , lipstickColorCode : String , lipstickImageList : [LipstickImages]) {
        
        self.lipstickColorId = lipstickColorId
        self.lipstickColorName = lipstickColorName
        self.lipstickRGB = lipstickRGB
        self.lipstickColorCode = lipstickColorCode
        self.lipstickImageList = lipstickImageList
        
    }
    
}
