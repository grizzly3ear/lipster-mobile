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
    var createdAt: Date
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(image, forKey: "image")
        aCoder.encode(lipstickColor, forKey: "lipstickColor")
        aCoder.encode(skinColor, forKey: "skinColor")
        aCoder.encode(detail, forKey: "detail")
        aCoder.encode(createdAt, forKey: "createdAt")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let title = aDecoder.decodeObject(forKey: "title") as! String
        let image = aDecoder.decodeObject(forKey: "image") as! String
        let lipstickColor = aDecoder.decodeObject(forKey: "lipstickColor") as! UIColor
        let skinColor = aDecoder.decodeObject(forKey: "skinColor") as! UIColor
        let detail = aDecoder.decodeObject(forKey: "detail") as! String
        let createdAt = aDecoder.decodeObject(forKey: "createdAt") as! Date
        self.init(title, image, lipstickColor, skinColor, detail, createdAt)
    }
    
    init(_ title: String, _ trendImage: String, _ trendLipstickColor: UIColor, _ trendSkinColor: UIColor, _ trendDescription: String, _ createdAt: Date = Date()) {
        self.title = title
        self.image = trendImage
        self.lipstickColor = trendLipstickColor
        self.skinColor = trendSkinColor
        self.detail = trendDescription
        self.createdAt = createdAt
    }
    
    override init() {
        title = String()
        image = String()
        lipstickColor = .black
        skinColor = .black
        detail = String()
        createdAt = Date()
    }
    
    public static func getTrendArrayFromUserDefault(forKey: String) -> [Trend] {
        if let encodedFavTrends = UserDefaults.standard.data(forKey: forKey) {
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
            
//            2019-10-22T04:58:41.000000Z
            let createdAtString = trend["created_at"].stringValue

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            let createdAt = dateFormatter.date(from: createdAtString) ?? Date()
            
            trends.append(Trend(title, image, lipstickColor, skinColor, description, createdAt))
        }
        return trends
        
    }
    
    public static func ==(lhs: Trend, rhs: Trend) -> Bool {
        return lhs.title == rhs.title && lhs.detail == rhs.detail && lhs.image == rhs.image && lhs.detail == rhs.detail
    }
    
    static func mockArrayData(size: Int) -> [Trend] {
        var trends = [Trend]()
        for i in 0..<size {
            trends.append(Trend("Trend\(i)", "", .red, .orange, "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco"))
        }
        return trends
    }
    
    static func toggleTrendFav(_ trend: Trend?) {
        if trend != nil {
            var favTrends: [Trend] = Trend.getTrendArrayFromUserDefault(forKey: DefaultConstant.favoriteTrends)
            
            if let i = favTrends.firstIndex(where: { $0 == trend! }) {
                favTrends.remove(at: i)
                
            } else {
                favTrends.append(trend!)
            }
            Trend.setTrendArrayToUserDefault(forKey: DefaultConstant.favoriteTrends, favTrends)
        }
    }
    static func isTrendFav(_ trend: Trend?) -> Bool {
        if trend != nil {
            let favTrends: [Trend] = Trend.getTrendArrayFromUserDefault(forKey: DefaultConstant.favoriteTrends)
            
            if let _ = favTrends.firstIndex(where: { $0 == trend! }) {
                return true
            }
        }
        return false
    }
}
