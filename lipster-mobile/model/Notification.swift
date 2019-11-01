//
//  Notification.swift
//  lipster-mobile
//
//  Created by Bank on 25/4/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class Notification {
    
    var title : String
    var body: String
    var date : String
    var destination : String
    var image : String
    
    init(title: String, description: String , dateAndTime : String , destination : String , image : String) {
        self.title = title
        self.body = description
        self.date = dateAndTime
        self.destination = destination
        self.image = image
       
    }
    init(){
        title = String()
        body = String()
        date = String()
        destination = String()
        image = String()
        
    }
}
