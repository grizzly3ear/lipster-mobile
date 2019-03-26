//
//  File.swift
//  lipster-mobile
//
//  Created by Mainatvara on 14/3/2562 BE.
//  Copyright © 2562 Mainatvara. All rights reserved.
//

import Foundation
import UIKit

class Lipstick {
    
    var lipstickImage: UIImage
    var lipstickBrand: String
    var lipstickName: String
    var lipstickColorName: String
    var lipShortDetail: String
    
    init(lipstickImage: UIImage,lipstickBrand : String, lipstickName: String ,lipstickColorName : String, lipShortDetail : String ) {
        self.lipstickImage = lipstickImage
        self.lipstickBrand = lipstickBrand
        self.lipstickName =  lipstickName
        self.lipstickColorName = lipstickColorName
        self.lipShortDetail = lipShortDetail
    }
}
