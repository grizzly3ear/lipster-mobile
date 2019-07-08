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
        trendHomeImageView.layer.cornerRadius = 20
        trendHomeImageView.clipsToBounds = true
        
//        trendHomeImageView.layer.shadowColor = UIColor.black.cgColor
//        trendHomeImageView.layer.shadowOffset = CGSize(width:10.0,height: 10.0)
//        trendHomeImageView.layer.shadowRadius = 6.0
//        trendHomeImageView.layer.shadowOpacity = 0.7
//        trendHomeImageView.layer.masksToBounds = true;
    }
}
