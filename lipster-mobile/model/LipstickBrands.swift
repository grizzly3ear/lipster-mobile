//
//  LipstickBrands.swift
//  lipster-mobile
//
//  Created by Mainatvara on 24/4/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class LipstickBrands {
    
    var lipstickBrandId : String
    var lipstickBrand : String
    var lipstickDetailGroups : [LipstickDetails]?
    
    init(lipstickBrandId : String ,lipstickBrand : String , lipstickDetailGroups : [LipstickDetails]) {
        
        self.lipstickBrandId = lipstickBrandId
        self.lipstickBrand = lipstickBrand
        self.lipstickDetailGroups = lipstickDetailGroups
    }
}
