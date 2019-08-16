//
//  Store.swift
//  lipster-mobile
//
//  Created by Mainatvara on 16/8/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import Foundation
import UIKit

class Store {
    
    var storeLogoImage : UIImage
    var storeName : String
    var storeHours : String
    var storeAddress : String
    
    
    init( storeLogoImage: UIImage , storeName : String , storeHours : String , storeAddress : String) {
        self.storeLogoImage = storeLogoImage
        self.storeName = storeName
        self.storeHours = storeHours
        self.storeAddress = storeAddress
    }
}
