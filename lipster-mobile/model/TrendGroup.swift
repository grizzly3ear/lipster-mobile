//
//  TrendGroup.swift
//  lipster-mobile
//
//  Created by Mainatvara on 22/4/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit
import SwiftyJSON

class TrendGroup: NSObject, NSCoding {
    var name: String?
    var trends: [Trend]?
    var image: String?
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(image, forKey: "image")
        aCoder.encode(trends, forKey: "trends")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let image = aDecoder.decodeObject(forKey: "image") as! String
        let trends = aDecoder.decodeObject(forKey: "trends") as! [Trend]
        self.init(name, trends, image)
    }
    
    init(_ name: String, _ trends: [Trend], _ image: String) {
        self.name = name
        self.trends = trends
        self.image = image
    }
    
    override init() {
        self.name = String()
        self.trends = [Trend]()
        self.image = String()
    }
    
    public static func makeArrayModelFromJSON(response: JSON?) -> [TrendGroup] {
        var trendCollections = [TrendGroup]()

        if response == nil {
            return trendCollections
        }
        for trendCollectionJSON in response! {
            let trendCollection = trendCollectionJSON.1
            let name = trendCollection["name"].stringValue
            let image = trendCollection["image"].stringValue
            let trends = Trend.makeArrayModelFromJSON(response: trendCollection["trends"])
            
            trendCollections.append(TrendGroup(name, trends, image))
        }
        
        return trendCollections
    }
    
    public static func getTrendGroupArrayFromUserDefault(forKey: String) -> [TrendGroup] {
        if let encodedFavTrends = UserDefaults.standard.data(forKey: forKey) {
            return NSKeyedUnarchiver.unarchiveObject(with: encodedFavTrends) as! [TrendGroup]
        }
        return [TrendGroup]()
    }
    
    public static func setTrendGroupArrayToUserDefault(forKey: String, _ arr: [TrendGroup]) {
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: arr)
        UserDefaults.standard.set(encodedData, forKey: forKey)
    }
    
    static func mockArrayData(size: Int) ->[TrendGroup]{
        var trendGroups = [TrendGroup]()
        for i in 0..<size {
            trendGroups.append(TrendGroup("trendGroup\(i)", Trend.mockArrayData(size: 3), ""))
        }
        return trendGroups
    }
}
