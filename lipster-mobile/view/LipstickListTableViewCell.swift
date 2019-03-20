//
//  LipstickListTableViewCell.swift
//  lipster-mobile
//
//  Created by Mainatvara on 13/3/2562 BE.
//  Copyright © 2562 Mainatvara. All rights reserved.
//

import UIKit

class LipstickListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lipNameLabel: UILabel!
    @IBOutlet weak var lipImageView: UIImageView!
    @IBOutlet weak var lipShortDetail: UILabel!
    
    func setLipstick(lipstick : Lipstick) {
        lipImageView.image = lipstick.lipstickImage
        lipNameLabel.text = lipstick.lipstickName
        lipShortDetail.text = lipstick.lipShortDetail
    }
    
}
