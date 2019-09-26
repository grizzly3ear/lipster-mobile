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
    @IBOutlet weak var storehours: UILabel!
    @IBOutlet weak var storeAddress: UILabel!
    @IBOutlet weak var storePhoneNumber: UILabel!
    
    func setStore(store: Store) {
        //storeLogoImage.sd_setImage(with: URL(string: store.storeLogoImage), placeholderImage: UIImage(named: "nopic"))
        storeLogoImage.image = store.image
        storeName.text = store.name
        storehours.text = store.hours
        storeAddress.text = store.address
        storePhoneNumber.text = store.phoneNumber
    }
}
