//
//  TrendGroupCollectionViewCell.swift
//  lipster-mobile
//
//  Created by Bank on 8/8/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class TrendGroupCollectionViewCell: UICollectionViewCell {
    @IBOutlet var image: UIImageView!
    @IBOutlet weak var likeImageViewWidthConstraint: NSLayoutConstraint!
    
    lazy var likeAnimator = LikeAnimator(
        container: contentView,
        layoutConstraint: likeImageViewWidthConstraint,
        popupSize: 60
    )
    
}
