//
//  TrendGroup.swift
//  lipster-mobile
//
//  Created by Mainatvara on 22/4/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class TrendGroup {
    var trendName: String?
    var trends: [Trend]?
    
    init(_ trendName: String, _ trends: [Trend]) {
        self.trendName = trendName
        self.trends = trends
    }
    
    init() {
        
    }
}
