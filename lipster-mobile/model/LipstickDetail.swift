//
//  LipstickDetails.swift
//  lipster-mobile
//
//  Created by Mainatvara on 24/4/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class LipstickDetail {
    
    var lipstickDetailId : Int
    var lipstickName : String
    var lipstickMinPrice : Double
    var lipstickMaxPrice : Double
    var lipstickType : String
    var lipstickOpacity : Double
    var lipstickDescription : String
    var lipstickComposition : String
    var lipstickApply : String
    var lipstickColors  : [LipstickColor]?
    
    init(lipstickDetailId : Int, lipstickName : String, lipstickMinPrice : Double,lipstickMaxPrice : Double,  lipstickType : String, lipstickOpacity : Double,  lipstickDescription : String, lipstickComposition : String, lipstickApply : String, lipstickColors  : [LipstickColor]) {
        self.lipstickDetailId = lipstickDetailId
        self.lipstickName = lipstickName
        self.lipstickMinPrice = lipstickMinPrice
        self.lipstickMaxPrice = lipstickMaxPrice
        self.lipstickType = lipstickType
        self.lipstickOpacity = lipstickOpacity
        self.lipstickDescription = lipstickDescription
        self.lipstickComposition = lipstickComposition
        self.lipstickApply = lipstickApply
        self.lipstickColors = lipstickColors
    }
    
    init() {
        self.lipstickDetailId = Int()
        self.lipstickName = String()
        self.lipstickMinPrice = Double()
        self.lipstickMaxPrice = Double()
        self.lipstickType = String()
        self.lipstickOpacity = Double()
        self.lipstickDescription = String()
        self.lipstickComposition = String()
        self.lipstickApply = String()
        self.lipstickColors = [LipstickColor]()
    }
}
