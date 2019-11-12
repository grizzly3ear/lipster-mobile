//
//  UserReview.swift
//  lipster-mobile
//
//  Created by Mainatvara on 2/4/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import SDWebImage

class UserReview {
    
    var userReview : String
    var user : User
    var dateReview : Date
    var lipstick: Lipstick
    
    init(userReview : String , user : User , dateReview : Date, lipstick: Lipstick = Lipstick()) {
        self.userReview = userReview
        self.user = user
        self.dateReview = dateReview
        self.lipstick = lipstick
    }
    
    public static func makeArrayModelFromJSON(response: JSON?) -> [UserReview] {
        var reviews = [UserReview]()
        if response == nil {
            return reviews
        }
        for review in response! {
            let _ = review.1["rating"].intValue
            let comment = review.1["comment"].stringValue
            let user = User.makeModelFromUserJSON(response: review.1["user"])
            let _ = review.1["skin_color"].stringValue
            let dateReviewString = review.1["created_at"].stringValue
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            let dateReview = dateFormatter.date(from: dateReviewString) ?? Date()
            
            reviews.append(UserReview(userReview: comment, user: user!, dateReview: dateReview))
        }
        
        return reviews
    }
    
    public static func makeArrayModelFromUserJSON(response: JSON?) -> [UserReview] {
            var reviews = [UserReview]()
            if response == nil {
                return reviews
            }
        for review in response!["reviews"] {
            let _ = review.1["rating"].intValue
            let comment = review.1["comment"].stringValue
            let user = User.makeModelFromUserJSON(response: response!)
            let _ = review.1["skin_color"].stringValue
            
            let dateReviewString = review.1["created_at"].stringValue
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            let dateReview = dateFormatter.date(from: dateReviewString) ?? Date()
            
            let lipstick = Lipstick.makeModelFromColorJSON(response: review.1["lipstick_color"])
                reviews.append(UserReview(userReview: comment, user: user!, dateReview: dateReview, lipstick: lipstick))
            }
            
            return reviews
        }
}
