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
    
    var userProfile : UIImage
    var userReview : String
    var userName : String
    var dateReview : String
    
    
    init(userProfile : UIImage , userReview : String , userName : String , dateReview : String) {
        self.userProfile = userProfile
        self.userReview = userReview
        self.userName = userName
        self.dateReview = dateReview
    }
    
    public static func makeArrayModelFromJSON(response: JSON?) -> [UserReview] {
        var reviews = [UserReview]()
        if response == nil {
            return reviews
        }
        for review in response! {
            let _ = review.1["rating"].intValue
            let comment = review.1["comment"].stringValue
            let user = review.1["user"].stringValue
            let _ = review.1["skin_color"].stringValue
            let dateReview = review.1["date"].stringValue
            reviews.append(UserReview(userProfile: UIImage(named: "username")!, userReview: comment, userName: user, dateReview: dateReview))
        }
        
        return reviews
    }
}
