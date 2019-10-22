//
//  Store.swift
//  lipster-mobile
//
//  Created by Mainatvara on 16/8/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class Store {
    
    var id: Int
    var image : String
    var name : String
    var hours : String
    var address : String
    var latitude : Double
    var longitude : Double
    var phoneNumber : String
    var branch : String
    
    
    init(id: Int, storeLogoImage: String , storeName : String , storeHours : String , storeAddress : String , storeLatitude : Double , storeLongitude : Double , storePhoneNumber : String , storeBranch : String = "") {
        self.id = id
        self.image = storeLogoImage
        self.name = storeName
        self.hours = storeHours
        self.address = storeAddress
        self.latitude = storeLatitude
        self.longitude = storeLongitude
        self.phoneNumber = storePhoneNumber
        self.branch = storeBranch
    }
    
    public static func makeArrayModelFromJSON(response: JSON?) -> [Store] {
        var stores = [Store]()
        
        if response == nil {
            return stores
        }
        for storeJSON in response! {
            let store = storeJSON.1
            
            for storeAddressJSON in store["addresses"] {
                let storeAddress = storeAddressJSON.1
                
                let id = store["id"].intValue
                let name = store["name"].stringValue
                let image = store["image"].stringValue
                let latitude = storeAddress["latitude"].doubleValue
                let longtitude = storeAddress["longtitude"].doubleValue
                let addressDetail = storeAddress["address_detail"].stringValue
                let period = storeAddress["period"].stringValue
                let tel = storeAddress["tel"].stringValue
                
                let branch = storeAddress["name"].stringValue
                stores.append(Store(id: id, storeLogoImage: image, storeName: name, storeHours: period, storeAddress: addressDetail, storeLatitude: latitude, storeLongitude: longtitude, storePhoneNumber: tel , storeBranch: branch))
            }
        }
        return stores
    }
}
