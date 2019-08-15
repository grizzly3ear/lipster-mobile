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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
