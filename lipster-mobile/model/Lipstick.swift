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

class Lipstick: NSObject, NSCoding {

    var lipstickId: Int
    var lipstickImage: [String]
    var lipstickBrand: String
    var lipstickName: String
    var lipstickColorName: String
    var lipstickDetail: String
    var lipstickColor : UIColor
    var lipstickDetailId: Int
    var lipstickIngredients: String
    var lipstickOpacity: CGFloat
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(lipstickId, forKey: "lipstickId")
        aCoder.encode(lipstickImage, forKey: "lipstickImage")
        aCoder.encode(lipstickBrand, forKey: "lipstickBrand")
        aCoder.encode(lipstickName, forKey: "lipstickName")
        aCoder.encode(lipstickColorName, forKey: "lipstickColorName")
        aCoder.encode(lipstickDetail, forKey: "lipstickDetail")
        aCoder.encode(lipstickColor, forKey: "lipstickColor")
        aCoder.encode(lipstickDetailId, forKey: "lipstickDetailId")
        aCoder.encode(lipstickIngredients, forKey: "lipstickIngredients")
        aCoder.encode(lipstickOpacity, forKey: "lipstickOpacity")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let lipstickId = aDecoder.decodeInteger(forKey: "lipstickId")
        let lipstickImage = aDecoder.decodeObject(forKey: "lipstickImage") as! [String]
        let lipstickBrand = aDecoder.decodeObject(forKey: "lipstickBrand") as! String
        let lipstickName = aDecoder.decodeObject(forKey: "lipstickName") as! String
        let lipstickColorName = aDecoder.decodeObject(forKey: "lipstickColorName") as! String
        let lisptickDetail = aDecoder.decodeObject(forKey: "lipstickDetail") as! String
        let lipstickColor = aDecoder.decodeObject(forKey: "lipstickColor") as! UIColor
        let lipstickDetailId = aDecoder.decodeInteger(forKey: "lipstickDetailId")
        let lipstickIngredients = aDecoder.decodeObject(forKey: "lipstickIngredients") as! String
        let lipstickOpacity = aDecoder.decodeObject(forKey: "lipstickOpacity") as! CGFloat
        self.init(lipstickId, lipstickImage, lipstickBrand, lipstickName, lipstickColorName, lisptickDetail, lipstickColor, lipstickDetailId, lipstickIngredients, lipstickOpacity)
    }

    init(_ lipstickId: Int, _ lipstickImage: [String], _ lipstickBrand: String, _ lipstickName: String, _ lipstickColorName: String, _ lipShortDetail: String, _ lipstickColor: UIColor, _ lipstickDetailId: Int, _ lipstickIngredients: String = "", _ lipstickOpacity: CGFloat = 0.3) {
        self.lipstickId = lipstickId
        self.lipstickImage = lipstickImage
        self.lipstickBrand = lipstickBrand
        self.lipstickName =  lipstickName
        self.lipstickColorName = lipstickColorName
        self.lipstickDetail = lipShortDetail
        self.lipstickColor = lipstickColor
        self.lipstickDetailId = lipstickDetailId
        self.lipstickIngredients = lipstickIngredients
        self.lipstickOpacity = lipstickOpacity
    }
    
    override init() {
        self.lipstickId = Int()
        self.lipstickImage = [String]()
        self.lipstickBrand = String()
        self.lipstickName =  String()
        self.lipstickColorName = String()
        self.lipstickDetail = String()
        self.lipstickColor = UIColor()
        self.lipstickDetailId = Int()
        self.lipstickIngredients = String()
        self.lipstickOpacity = CGFloat()
    }
    static func mockArrayData(size: Int) -> [Lipstick] {
        var lipsticks = [Lipstick]()
        for i in 0..<size {
            if i%2 == 0 {
                lipsticks.append(Lipstick(i, [""], "LANCOME","Velvet Matte Lipstick Pencil", "Roman Holiday - vibrant pink sheen", "detail", .red, 03, ""))
            } else {
                lipsticks.append(Lipstick(i, [""], "LANCOME","Red Velvet", "Roman Holiday - vibrant pink sheen", "detail", .red, 03, ""))
            }
            
        }
        return lipsticks
    }
    public static func makeArrayModelFromBrandJSON(response: JSON?) -> [Lipstick] {
        var lipsticks = [Lipstick]()
        
        if response == nil {
            return lipsticks
        }
        for brand in response! {
            
            for lipstickDetail in brand.1["details"] {
                
                for lipstickColorJSON in lipstickDetail.1["colors"] {
                    
                    var images = [String]()
                    for image in lipstickColorJSON.1["images"] {
                        images.append(image.1["image"].stringValue)
                    }
                    let lipstickId = lipstickColorJSON.1["id"].intValue
                    let lipstickBrand = brand.1["name"].stringValue
                    let lipstickName = lipstickDetail.1["name"].stringValue
                    let lipstickColorName = lipstickColorJSON.1["color_name"].stringValue
                    let lipstickDescription = lipstickDetail.1["description"].stringValue
                    let lipstickColor = UIColor.init(hexString: lipstickColorJSON.1["rgb"].stringValue)
                    let lipstickDetailId = lipstickDetail.1["id"].intValue
                    let lipstickIngredients = lipstickColorJSON.1["composition"].stringValue
                    let lipstickOpacity = lipstickDetail.1["opacity"].floatValue
                    
                    lipsticks.append(Lipstick(lipstickId, images, lipstickBrand, lipstickName, lipstickColorName, lipstickDescription, lipstickColor, lipstickDetailId, lipstickIngredients, CGFloat(lipstickOpacity)))
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
                response!["id"].intValue,
                lipstick["composition"].stringValue,
                CGFloat(response!["opacity"].floatValue)
            ))
            
        }
        return lipsticks
    }
    
    public static func makeArrayModelFromColorJSON(response: JSON?) -> [Lipstick] {
        var lipsticks = [Lipstick]()
        
        if response == nil {
            return lipsticks
        }
        for lipstick in response! {
            let id = lipstick.1["id"].intValue
            var images = [String]()
            for image in lipstick.1["images"] {
                images.append(image.1["image"].stringValue)
            }
            let brandName = lipstick.1["brand"]["name"].stringValue
            let name = lipstick.1["detail"]["name"].stringValue
            let colorName = lipstick.1["color_name"].stringValue
            let description = lipstick.1["detail"]["description"].stringValue
            let color = UIColor(hexString: lipstick.1["rgb"].stringValue)
            let detailId = lipstick.1["detail"]["id"].intValue
            let opacity = lipstick.1["detail"]["opacity"].floatValue
            let composition = lipstick.1["composition"].stringValue
            
            lipsticks.append(Lipstick(
                id,
                images,
                brandName,
                name,
                colorName,
                description,
                color,
                detailId,
                composition,
                CGFloat(opacity)
            ))
        }
        return lipsticks
    }
    
    public static func makeModelFromColorJSON(response: JSON?) -> Lipstick {
        
        if response == nil {
            return Lipstick()
        }
        
        if let lipstick = response {
            let id = lipstick["id"].intValue
            var images = [String]()
            for image in lipstick["images"] {
                images.append(image.1["image"].stringValue)
            }
            let brandName = lipstick["brand"]["name"].stringValue
            let name = lipstick["detail"]["name"].stringValue
            let colorName = lipstick["color_name"].stringValue
            let description = lipstick["detail"]["description"].stringValue
            let color = UIColor(hexString: lipstick["rgb"].stringValue)
            let detailId = lipstick["detail"]["id"].intValue
            let opacity = lipstick["detail"]["opaciry"].floatValue
            let composition = lipstick["composition"].stringValue
            
            return Lipstick(
                id,
                images,
                brandName,
                name,
                colorName,
                description,
                color,
                detailId,
                composition,
                CGFloat(opacity)
            )
        }
        return Lipstick()
    }
    
    public static func getLipstickArrayFromUserDefault(forKey: String) -> [Lipstick] {
        if let encodedLipstick = UserDefaults.standard.data(forKey: forKey) {
            return NSKeyedUnarchiver.unarchiveObject(with: encodedLipstick) as! [Lipstick]
        }
        return [Lipstick]()
    }
    
    public static func setLipstickArrayToUserDefault(forKey: String, _ arr: [Lipstick]) {
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: arr)
        UserDefaults.standard.set(encodedData, forKey: forKey)
    }
    
    public static func ==(lhs: Lipstick, rhs: Lipstick) -> Bool {
        return lhs.lipstickId == rhs.lipstickId && lhs.lipstickDetailId == rhs.lipstickDetailId && lhs.lipstickColorName == rhs.lipstickColorName
    }
    
    static func isLipstickFav(_ lipstick: Lipstick?) -> Bool {
        if lipstick != nil {
            let favLipstick: [Lipstick] = Lipstick.getLipstickArrayFromUserDefault(forKey: DefaultConstant.favoriteLipsticks)
            
            if let _ = favLipstick.firstIndex(where: { $0 == lipstick! }) {
                return true
            }
        }
        return false
    }
    
    static func toggleFavLipstick(_ lipstick: Lipstick?) {
        if lipstick != nil {
            var favLipstick: [Lipstick] = Lipstick.getLipstickArrayFromUserDefault(forKey: DefaultConstant.favoriteLipsticks)
            
            if let i = favLipstick.firstIndex(where: { $0 == lipstick! }) {
                favLipstick.remove(at: i)
                
            } else {
                favLipstick.append(lipstick!)
            }
            Lipstick.setLipstickArrayToUserDefault(forKey: DefaultConstant.favoriteLipsticks, favLipstick)
        }
    }
    
}
