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

    var lipstickId: Int
    var lipstickImage: [String]
    var lipstickBrand: String
    var lipstickName: String
    var lipstickColorName: String
    var lipstickDetail: String
    var lipstickColor : UIColor
    var lipstickDetailId: Int

    init(_ lipstickId: Int, _ lipstickImage: [String], _ lipstickBrand: String, _ lipstickName: String, _ lipstickColorName: String, _ lipShortDetail: String, _ lipstickColor: UIColor, _ lipstickDetailId: Int) {
        self.lipstickId = lipstickId
        self.lipstickImage = lipstickImage
        self.lipstickBrand = lipstickBrand
        self.lipstickName =  lipstickName
        self.lipstickColorName = lipstickColorName
        self.lipstickDetail = lipShortDetail
        self.lipstickColor = lipstickColor
        self.lipstickDetailId = lipstickDetailId
    }
    
    init() {
        self.lipstickId = Int()
        self.lipstickImage = [String]()
        self.lipstickBrand = String()
        self.lipstickName =  String()
        self.lipstickColorName = String()
        self.lipstickDetail = String()
        self.lipstickColor = UIColor()
        self.lipstickDetailId = Int()
    }
    
    public static func makeArrayModelFromBrandJSON(response: JSON?) -> [Lipstick] {
        var lipsticks = [Lipstick]()
        
        if response == nil {
            return lipsticks
        }
        for brand in response! {
            
            for lipstickDetail in brand.1["details"] {
                
                for lipstickColor in lipstickDetail.1["colors"] {
                    
                    var images = [String]()
                    for image in lipstickColor.1["images"] {
                        images.append(image.1["image"].stringValue)
                    }
                    let lipstickId = lipstickColor.1["id"].intValue
                    let lipstickBrand = brand.1["name"].stringValue
                    let lipstickName = lipstickDetail.1["name"].stringValue
                    let lipstickColorName = lipstickColor.1["color_name"].stringValue
                    let lipstickDescription = lipstickDetail.1["description"].stringValue
                    let lipstickColor = UIColor.init(hexString: lipstickColor.1["rgb"].stringValue)
                    let lipstickDetailId = lipstickDetail.1["id"].intValue
                    
                    lipsticks.append(Lipstick(lipstickId, images, lipstickBrand, lipstickName, lipstickColorName, lipstickDescription, lipstickColor, lipstickDetailId))
                }
            }
        }
        return lipsticks
    }
    
    public static func makeArrayModelFromDetailJSON(response: JSON?) -> [Lipstick] {
        var lipsticks = [Lipstick]()
        
        if response == nil {
            return lipsticks
        }
        let colors = response!["colors"]
        let brand = response!["brand"]["name"].stringValue
        for color in colors {
            let lipstick = color.1
            var images = [String]()
            for image in lipstick["images"] {
                images.append(image.1["image"].stringValue)
            }
            lipsticks.append(Lipstick(
                lipstick["id"].intValue,
                images,
                brand,
                response!["name"].stringValue,
                lipstick["color_name"].stringValue,
                response!["description"].stringValue,
                UIColor(hexString: lipstick["rgb"].stringValue),
                response!["id"].intValue
            ))
            
        }

        return lipsticks
    }
    
    public static func makeArrayFromLipstickColorResource(response: JSON?) -> [Lipstick] {
        var lipsticks = [Lipstick]()
        
        if response == nil {
            return lipsticks
        }
        for lipstick in response! {
            
            let lipstickId = lipstick.1["id"].intValue
            let lipstickBrand = lipstick.1["brand"]["name"].stringValue
            let lipstickName = lipstick.1["color_name"].stringValue
            let lipstickColorName = lipstick.1[""].stringValue
            let lipstickDetail = lipstick.1["detail"].stringValue
            let lipstickColor = UIColor(hexString: lipstick.1["rgb"].stringValue)
            var images = [String]()
            for image in lipstick.1["images"] {
                images.append(image.1["image"].stringValue)
            }
            let lipstickImages = images
            let lipstickDetailId = lipstick.1["detail"]["id"].intValue
            
            lipsticks.append(Lipstick(lipstickId, lipstickImages, lipstickBrand, lipstickName, lipstickColorName, lipstickDetail, lipstickColor, lipstickDetailId))
        }
        return lipsticks
    }
    
}
