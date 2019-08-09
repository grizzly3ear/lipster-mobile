//
//  YourReviewedTableViewCell.swift
//  lipster-mobile
//
//  Created by Mainatvara on 9/8/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class YourReviewsTableViewCell: UITableViewCell {

    @IBOutlet weak var reviewImageView: UIImageView!
    @IBOutlet weak var reviewBrandLabel: UILabel!
    @IBOutlet weak var reviewColorNameLabel: UILabel!
    @IBOutlet weak var reviewNameLabel: UILabel!
    
    @IBOutlet weak var reviewFromUserLabel: UILabel!
    @IBOutlet weak var dateReview: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUserReview(userReviews : UserReview) {
        reviewFromUserLabel.text = userReviews.userReview
        dateReview.text = userReviews.dateReview

    }
    func setLipstick(lipstick : Lipstick) {
        reviewImageView.sd_setImage(with: URL(string: lipstick.lipstickImage.first ?? ""), placeholderImage: UIImage(named: "nopic"))
        reviewBrandLabel.text = lipstick.lipstickBrand
        reviewColorNameLabel.text = lipstick.lipstickColorName
        reviewNameLabel.text = lipstick.lipstickName
      
    }
    


}
