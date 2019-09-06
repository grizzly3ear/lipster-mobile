//
//  TrendGroup2CollectionViewCell.swift
//  lipster-mobile
//
//  Created by Mainatvara on 15/8/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class TrendGroup2CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var trendImage: UIImageView!
    
    func setTrend(trend : Trend) {
        trendImage.sd_setImage(with: URL(string: trend.image), placeholderImage: UIImage(named: "nopic"))
    
        
    }
}
