//
//  Notification.swift
//  lipster-mobile
//
//  Created by Bank on 25/4/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit
import SwiftyJSON

class UserNotification {
    
    var id: Int
    var title: String
    var body: String
    var createdAt: Date
    var destination: String
    var image: String
    var modelName: String
    var modelId: Int
    var isRead: Bool
    
    init(id: Int, title: String, body: String, createdAt: Date, destination: String, image: String, modelName: String, modelId: Int, read: Int = 0) {
        self.id = id
        self.title = title
        self.body = body
        self.createdAt = createdAt
        self.destination = destination
        self.image = image
        self.modelName = modelName
        self.modelId = modelId
        self.isRead = read != 0
    }
    
    init(){
        id = Int()
        title = String()
        body = String()
        createdAt = Date()
        destination = String()
        image = String()
        modelName = String()
        modelId = Int()
        isRead = false
    }
    
    public static func makeArrayModelFromJSON(response: JSON?) -> [UserNotification] {
        var notifications = [UserNotification]()
        
        if response == nil {
            return notifications
        }
        
        for notification in response! {
            let id = notification.1["id"].intValue
            
            let title = notification.1["title"].stringValue
            let body = notification.1["body"].stringValue
            let createdAtString = notification.1["created_at"].stringValue
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            let createdAt = dateFormatter.date(from: createdAtString) ?? Date()
            
            let modelName = notification.1["name"].stringValue
            let modelId = notification.1["notification_id"].intValue
            
            let image = notification.1[modelName]["image"].stringValue
            var destination = String()
            
            if modelName == "trend_group" {
                destination = "PinterestCollectionViewController"
            } else if modelName == "lipstick_color" {
                
            }
            let readState = notification.1["read"].intValue
            
            notifications.append(UserNotification(id: id, title: title, body: body, createdAt: createdAt, destination: destination, image: image, modelName: modelName, modelId: modelId, read: readState))
        }

        return notifications
    }
    
    public static func makeModelFromJSON(response: JSON?) -> UserNotification {
        if response == nil {
            return UserNotification()
        }
        let notification = response!
        let id = notification["id"].intValue
                   
        let title = notification["title"].stringValue
        let body = notification["body"].stringValue
        let createdAtString = notification["created_at"].stringValue

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        let createdAt = dateFormatter.date(from: createdAtString) ?? Date()

        let modelName = notification["name"].stringValue
        let modelId = notification["notification_id"].intValue

        let image = notification[modelName]["image"].stringValue
        var destination = String()

        if modelName == "trend_group" {
           destination = "PinterestCollectionViewController"
        } else if modelName == "lipstick_color" {
           
        }
        let readState = notification["read"].intValue

        return UserNotification(id: id, title: title, body: body, createdAt: createdAt, destination: destination, image: image, modelName: modelName, modelId: modelId, read: readState)
    }
}
