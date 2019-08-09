//
//  TrendGroup.swift
//  lipster-mobile
//
//  Created by Mainatvara on 22/4/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit
import SwiftyJSON

class TrendGroup {
    var name: String?
    var trends: [Trend]?
    var image: String?
    
    init(_ name: String, _ trends: [Trend], _ image: String) {
        self.name = name
        self.trends = trends
        self.image = image
    }
    
    init() {
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
}
