//
//  NearByCollectionViewCell.swift
//  lipster-mobile
//
//  Created by Mainatvara on 17/8/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class NearByCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var storeLogoImage: UIImageView!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var storePeriod: UILabel!
    @IBOutlet weak var storeBranch: UILabel!
    
    func setStore(store: Store) {
        storeLogoImage.sd_setImage(with: URL(string: store.image), placeholderImage: UIImage(named: "nopic"))
        storeName.text = store.name
        let period = store.hours.split(separator: ";")
        storePeriod.text = "\(period[0]) - \(period[1])"
        storeBranch.text = store.branch
        
    }
}
