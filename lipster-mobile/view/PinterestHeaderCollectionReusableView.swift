//
//  PinterestHeaderCollectionReusableView.swift
//  lipster-mobile
//
//  Created by Bank on 21/10/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class PinterestHeaderCollectionReusableView: UICollectionReusableView {
        
    static let cellId: String = "PinterestHeaderCollectionReusableView"
    
    @IBOutlet weak var trendGroupLabel: UILabel!
    @IBOutlet weak var trendGroupImage: UIImageView!
    @IBOutlet weak var trendGroupDescription: UILabel!
    
    var trendGroup: TrendGroup? {
        didSet {
            trendGroupImage.sd_setImage(with: URL(string: trendGroup!.image!), placeholderImage: UIImage(named: "nopic")!)
            trendGroupImage.contentMode = .scaleAspectFill
            trendGroupLabel.text = trendGroup?.name
            trendGroupDescription.text = trendGroup?.trendDescription
        }
    }
}
