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
    
    
    init(userProfile : UIImage , userReview : String , userName : String ) {
        self.userProfile = userProfile
        self.userReview = userReview
        self.userName = userName
    }
    
    public static func makeArrayModelFromJSON(response: JSON?) -> [UserReview] {
        var reviews = [UserReview]()
        if response == nil {
            return reviews
        }
        for review in response! {
            print(review)
            let rating = review.1["rating"].intValue
            let comment = review.1["comment"].stringValue
            let user = review.1["user"].stringValue
            let skinColor = review.1["skin_color"].stringValue
            reviews.append(UserReview(userProfile: UIImage(named: "nopic")!, userReview: comment, userName: user))
        }
        
        return reviews
    }
}
