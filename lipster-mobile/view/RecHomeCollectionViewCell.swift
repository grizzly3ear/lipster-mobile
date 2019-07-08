//
//  RecHomeCollectionViewCell.swift
//  lipster-mobile
//
//  Created by Mainatvara on 19/4/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class RecommendHomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var recImageView: UIImageView!
    @IBOutlet weak var recBrandLabel: UILabel!
    @IBOutlet weak var recNameLabel: UILabel!
    
    override func awakeFromNib() {
        recImageView.layer.cornerRadius = 15
        recImageView.clipsToBounds = true
    }
}
