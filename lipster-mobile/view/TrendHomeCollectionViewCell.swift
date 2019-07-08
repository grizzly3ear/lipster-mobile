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
    
    override func awakeFromNib() {
        trendHomeImageView.layer.cornerRadius = 15
        trendHomeImageView.clipsToBounds = true
        
        trendHomeImageView.layer.shadowColor = UIColor.lightGray.cgColor
        trendHomeImageView.layer.shadowOffset = CGSize(width:2.0,height: 2.0)
        trendHomeImageView.layer.shadowRadius = 6.0
        trendHomeImageView.layer.shadowOpacity = 0.5
       // trendHomeImageView.layer.masksToBounds = true;
    }
}
