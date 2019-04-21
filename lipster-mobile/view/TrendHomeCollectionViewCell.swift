//
//  TrendHomeCollectionViewCell.swift
//  lipster-mobile
//
//  Created by Mainatvara on 19/4/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class TrendHomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var trendHomeImageView: UIImageView!
    @IBOutlet weak var trendNameLabel : UILabel!
    @IBOutlet weak var trendLipstickColorView: UIView!
    @IBOutlet weak var trendSkinColorView: UIView!
    
    
    func setTrend(trends :Trends) {
        trendHomeImageView.image = trends.trendImage
        trendNameLabel.text = trends.trendName
        trendLipstickColorView.backgroundColor = trends.trendLipstickColor
        trendSkinColorView.backgroundColor = trends.trendSkinColor
        
    }
}
