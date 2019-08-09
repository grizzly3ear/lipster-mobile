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

class Trend {
    
    var title: String
    var image: String
    var lipstickColor: UIColor
    var skinColor: UIColor
    var description: String
    
    init(_ title: String, _ trendImage: String, _ trendLipstickColor: UIColor, _ trendSkinColor: UIColor, _ trendDescription: String) {
        self.title = title
        self.image = trendImage
        self.lipstickColor = trendLipstickColor
        self.skinColor = trendSkinColor
        self.description = trendDescription   
    }
    
    init() {
        title = String()
        image = String()
        lipstickColor = .black
        skinColor = .black
        description = String()
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
}
