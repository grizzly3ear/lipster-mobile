//
//  Trends.swift
//  lipster-mobile
//
//  Created by Mainatvara on 21/4/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//
import Foundation
import UIKit
import SwiftyJSON

class Trend: NSObject, NSCoding {
    
    var title: String
    var image: String
    var lipstickColor: UIColor
    var skinColor: UIColor
    var detail: String
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(image, forKey: "image")
        aCoder.encode(lipstickColor, forKey: "lipstickColor")
        aCoder.encode(skinColor, forKey: "skinColor")
        aCoder.encode(detail, forKey: "detail")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let title = aDecoder.decodeObject(forKey: "title") as! String
        let image = aDecoder.decodeObject(forKey: "image") as! String
        let lipstickColor = aDecoder.decodeObject(forKey: "lipstickColor") as! UIColor
        let skinColor = aDecoder.decodeObject(forKey: "skinColor") as! UIColor
        let detail = aDecoder.decodeObject(forKey: "detail") as! String
        self.init(title, image, lipstickColor, skinColor, detail)
    }
    
    init(_ title: String, _ trendImage: String, _ trendLipstickColor: UIColor, _ trendSkinColor: UIColor, _ trendDescription: String) {
        self.title = title
        self.image = trendImage
        self.lipstickColor = trendLipstickColor
        self.skinColor = trendSkinColor
        self.detail = trendDescription   
    }
    
    override init() {
        title = String()
        image = String()
        lipstickColor = .black
        skinColor = .black
        detail = String()
    }
    
    public static func getTrendArrayFromUserDefault(forKey: String) -> [Trend] {
        if let encodedFavTrends = UserDefaults.standard.data(forKey: forKey) {
            print(encodedFavTrends)
            return NSKeyedUnarchiver.unarchiveObject(with: encodedFavTrends) as! [Trend]
        }
        return [Trend]()
    }
    
    public static func setTrendArrayToUserDefault(forKey: String, _ arr: [Trend]) {
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: arr)
        UserDefaults.standard.set(encodedData, forKey: forKey)
    }
    
    public static func makeArrayModelFromJSON(response: JSON?) -> [Trend] {
        var trends = [Trend]()

        if response == nil {
            return trends
        }
        for trendJSON in response! {
            let trend = trendJSON.1
            let title = trend["title"].stringValue
            let lipstickColor = UIColor(hexString: trend["lipstick_color"].stringValue)
            let image = trend["image"].stringValue
            let skinColor = UIColor(hexString: trend["skin_color"].stringValue)
            let description = trend["description"].stringValue
            
            trends.append(Trend(title, image, lipstickColor, skinColor, description))
        }
        return trends
        
    }
    
    public static func ==(lhs: Trend, rhs: Trend) -> Bool {
        return lhs.title == rhs.title && lhs.detail == rhs.detail && lhs.image == rhs.image && lhs.detail == rhs.detail
    }
}
