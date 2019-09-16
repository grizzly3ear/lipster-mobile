//
//  UserReviewTableViewCell.swift
//  lipster-mobile
//
//  Created by Mainatvara on 2/4/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class UserReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userReviewLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var reviewDate: UILabel!
    
    func setUserReview(user : UserReview) {
        userImage.image = user.userProfile
        userNameLabel.text = user.userName
        userReviewLabel.text = user.userReview
        reviewDate.text = user.dateReview
        
    }
    
    

}
