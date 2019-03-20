//
//  File.swift
//  lipster-mobile
//
//  Created by Mainatvara on 14/3/2562 BE.
//  Copyright © 2562 Mainatvara. All rights reserved.
//

import Foundation
import UIKit

class Lipstick {
    
    var lipstickImage: UIImage
    var lipstickName: String
    var lipShortDetail: String
    
    init(lipstickImage: UIImage, lipstickName: String , lipShortDetail : String ) {
        self.lipstickImage = lipstickImage
        self.lipstickName =  lipstickName
        self.lipShortDetail = lipShortDetail
    }
}
