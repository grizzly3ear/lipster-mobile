//
//  UserReviewTableViewCell.swift
//  lipster-mobile
//
//  Created by Mainatvara on 2/4/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit
import ExpandableLabel

class UserReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userReviewLabel: ExpandableLabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var reviewDate: UILabel!
    
    func setUserReview(user : UserReview) {
        userImage.sd_setImage(with: URL(string: user.user.imageURL!), placeholderImage: UIImage(named: "profile-user"))
        userNameLabel.text = user.user.firstname! + " " + user.user.lastname!
        userReviewLabel.text = user.userReview
        reviewDate.text = user.dateReview.formatDisplay()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userReviewLabel.collapsed = true
        userReviewLabel.text = nil
    }
    
    

}
