//
//  TrendGroupCollectionViewCell.swift
//  lipster-mobile
//
//  Created by Mainatvara on 22/4/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class TrendGroupTableViewCell: UITableViewCell {
    @IBOutlet weak var trendName: UILabel!
    @IBOutlet weak var trendImageCollectionView: UICollectionView!
    
    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, forRow row: Int) {
        trendImageCollectionView.delegate = dataSourceDelegate
        trendImageCollectionView.dataSource = dataSourceDelegate
        trendImageCollectionView.tag = row
        trendImageCollectionView.reloadData()
    }
    
}
