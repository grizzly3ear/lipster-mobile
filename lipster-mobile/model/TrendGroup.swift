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
    var trendName: String?
    var trends: [Trend]?
    
    init(_ trendName: String, _ trends: [Trend]) {
        self.trendName = trendName
        self.trends = trends
    }
    
    init() {
        
    }
    
    public static func makeModelFromJSON(response: JSON?) -> TrendGroup {
        let data = response!["data"]
        
        var trends = [Trend]()
        
        for trend in data {
            let trendImage = trend.1["image"].stringValue
            let trendLipstickColor = UIColor(hexString: trend.1["color"]["rgb"].stringValue)
            let trendSkinColor = UIColor(hexString: trend.1["skin_color"].stringValue)
            let trendDescription = "Summer - \(trend.1["title"].stringValue)"
            trends.append(Trend(trendImage: trendImage, trendLipstickColor: trendLipstickColor, trendSkinColor: trendSkinColor, trendDescription: trendDescription))
        }
        return TrendGroup("Summer", trends)
    }
}
