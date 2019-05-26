//
//  File.swift
//  lipster-mobile
//
//  Created by Mainatvara on 14/3/2562 BE.
//  Copyright © 2562 Mainatvara. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import SDWebImage

class Lipstick {

    var lipstickImage: [String]
    var lipstickBrand: String
    var lipstickName: String
    var lipstickColorName: String
    var lipstickDetail: String
    var lipstickColor : UIColor

    init(lipstickImage: [String],lipstickBrand : String, lipstickName: String ,lipstickColorName : String, lipShortDetail : String, lipstickColor : UIColor ) {
        self.lipstickImage = lipstickImage
        self.lipstickBrand = lipstickBrand
        self.lipstickName =  lipstickName
        self.lipstickColorName = lipstickColorName
        self.lipstickDetail = lipShortDetail
        self.lipstickColor = lipstickColor
    }
    
    init() {
        self.lipstickImage = [String]()
        self.lipstickBrand = String()
        self.lipstickName =  String()
        self.lipstickColorName = String()
        self.lipstickDetail = String()
        self.lipstickColor = UIColor()
    }
    
    public static func makeArrayModelFromJSON(response: JSON?) -> [Lipstick] {
        
        var lipsticks = [Lipstick]()
        
        let brandsJSON = response!["data"]
        
        for brand in brandsJSON {
            
            for lipstickDetail in brand.1["detail"] {
                
                for lipstickColor in lipstickDetail.1["colors"] {
                    
                    var images = [String]()
                    for image in lipstickColor.1["images"] {
                        print(image.1["image"].stringValue)
                        images.append(image.1["image"].stringValue)
//                        images.append(UIImage(named: "BE116")!)
                    }
                    let lipstickBrand = brand.1["name"].stringValue
                    let lipstickName = lipstickDetail.1["name"].stringValue
                    let lipstickColorName = lipstickColor.1["color_name"].stringValue
                    let lipstickDescription = lipstickDetail.1["description"].stringValue
                    let lipstickColor = UIColor.init(hexString: lipstickColor.1["rgb"].stringValue)
                    
                    lipsticks.append(Lipstick(lipstickImage: images, lipstickBrand: lipstickBrand, lipstickName: lipstickName, lipstickColorName: lipstickColorName, lipShortDetail: lipstickDescription, lipstickColor: lipstickColor))
                }
            }
        }
        return lipsticks
    }
    
}
