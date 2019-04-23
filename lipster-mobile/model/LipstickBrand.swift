//
//  LipstickBrands.swift
//  lipster-mobile
//
//  Created by Mainatvara on 24/4/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class LipstickBrand {
    
    var lipstickBrandId : Int
    var lipstickBrand : String
    var lipstickDetails : [LipstickDetail]?
    
    init(lipstickBrandId : Int, lipstickBrand : String, lipstickDetails : [LipstickDetail]) {
        
        self.lipstickBrandId = lipstickBrandId
        self.lipstickBrand = lipstickBrand
        self.lipstickDetails = lipstickDetails
    }
}
