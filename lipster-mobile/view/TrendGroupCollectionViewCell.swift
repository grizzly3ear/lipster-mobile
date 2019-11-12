//
//  NewTrendGroupCollectionViewCell.swift
//  lipster-mobile
//
//  Created by Mainatvara on 18/10/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class TrendGroupCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var trendGroupBackgroundImage: UIImageView!
    @IBOutlet weak var trendGroupName: UILabel!
   
    @IBOutlet weak var trendGroupDescription: UILabel!
    @IBOutlet weak var trendView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        trendView.backgroundColor = UIColor(white: 0, alpha: 0.5)
    }
    
    func setTrendGroup(trendGroup : TrendGroup) {
        trendGroupBackgroundImage.sd_setImage(with: URL(string: trendGroup.image!), placeholderImage: UIImage(named: "nopic"))
        trendGroupName.text = trendGroup.name
        trendGroupDescription.text = trendGroup.trendDescription
        
    }
}
