//
//  LipstickDetails.swift
//  lipster-mobile
//
//  Created by Mainatvara on 24/4/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class LipstickDetails {
    
    var lipstickDetailId : String
    var lipstickName : String
    var lipstickPrice : Int
    var lipstickType : String
    var lipstickOpacity : Int
    var lipstickDescription : String
    var lipstickComposition : String
    var lipstickApply : String
    var lipstickColorList  : [LipstickColors]?
    
    init(lipstickDetailId : String , lipstickName : String , lipstickPrice : Int
        , lipstickType : String , lipstickOpacity : Int ,  lipstickDescription : String , lipstickComposition : String , lipstickApply : String , lipstickColorList  : [LipstickColors]) {
        self.lipstickDetailId = lipstickDetailId
        self.lipstickName = lipstickName
        self.lipstickPrice = lipstickPrice
        self.lipstickType = lipstickType
        self.lipstickOpacity = lipstickOpacity
        self.lipstickDescription = lipstickDescription
        self.lipstickComposition = lipstickComposition
        self.lipstickApply = lipstickApply
        self.lipstickColorList = lipstickColorList
    }
}
