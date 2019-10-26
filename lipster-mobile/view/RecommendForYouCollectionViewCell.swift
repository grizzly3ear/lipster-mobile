//
//  RecommendForYouCollectionViewCell.swift
//  lipster-mobile
//
//  Created by Mainatvara on 26/10/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class RecommendForYouCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var recommendForYouImage: UIImageView!
    @IBOutlet weak var recommendForYouBrand: UILabel!
    @IBOutlet weak var recommendForYouName: UILabel!
    override func awakeFromNib() {
        recommendForYouImage.layer.cornerRadius = 20
    }
}
