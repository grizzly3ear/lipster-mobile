//
//  TrendGroup2TableViewCell.swift
//  lipster-mobile
//
//  Created by Mainatvara on 15/8/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class TrendGroup2TableViewCell: UITableViewCell {

    @IBOutlet weak var trendGroupImage: UIImageView!
    @IBOutlet weak var trendName: UILabel!
    @IBOutlet weak var trendCollectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func setTrendGroup(trendGroup : TrendGroup) {
        trendGroupImage.sd_setImage(with: URL(string: trendGroup.image!), placeholderImage: UIImage(named: "nopic"))
        trendName.text = trendGroup.name
        
      //  trendCollectionView.
        
    }

}
