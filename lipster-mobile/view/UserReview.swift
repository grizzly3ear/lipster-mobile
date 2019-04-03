//
//  UserReview.swift
//  lipster-mobile
//
//  Created by Mainatvara on 2/4/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import Foundation
import UIKit

class UserReview {
    
    var userProfile : UIImage
    var userReview : String
    var userName : String
    
    
    init(userProfile : UIImage , userReview : String , userName : String ) {
        self.userProfile = userProfile
        self.userReview = userReview
        self.userName = userName
        
    }
}
