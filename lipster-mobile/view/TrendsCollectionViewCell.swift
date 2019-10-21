//
//  TrendsCollectionViewCell.swift
//  lipster-mobile
//
//  Created by Mainatvara on 16/10/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class TrendsCollectionViewCell: UICollectionViewCell {
 
    @IBOutlet weak var trendImage: UIImageView!
    @IBOutlet weak var trendTitle: UILabel!
    @IBOutlet weak var TrendDescription: UILabel!
    
    
    override func awakeFromNib() {
        trendImage.layer.cornerRadius = 20
        trendImage.clipsToBounds = true
    }
    func setTrend(trend : Trend) {
        trendImage.sd_setImage(with: URL(string: trend.image), placeholderImage: UIImage(named: "nopic"))
        trendTitle.text = trend.title
        TrendDescription.text = trend.detail
        
        
    }
   
}
