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
    
    var image : UIImage
    var name : String
    var hours : String
    var address : String
    var latitude : Double
    var longitude : Double
    var phoneNumber : String
    
    
    init( storeLogoImage: UIImage , storeName : String , storeHours : String , storeAddress : String , storeLatitude : Double , storeLongitude : Double , storePhoneNumber : String) {
        self.image = storeLogoImage
        self.name = storeName
        self.hours = storeHours
        self.address = storeAddress
        self.latitude = storeLatitude
        self.longitude = storeLongitude
        self.phoneNumber = storePhoneNumber
    }
}
