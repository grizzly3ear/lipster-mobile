//
//  LipstickListTableViewCell.swift
//  lipster-mobile
//
//  Created by Mainatvara on 13/3/2562 BE.
//  Copyright © 2562 Mainatvara. All rights reserved.
//

import UIKit

class LipstickListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lipImageView: UIImageView!
    @IBOutlet weak var lipBrandLabel: UILabel!
    @IBOutlet weak var lipNameLabel: UILabel!
    @IBOutlet weak var lipColorNameLabel: UILabel!
    @IBOutlet weak var lipDetailLabel: UILabel!
    
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var colorUIView: UIView!
    
    func setLipstick(lipstick : Lipstick) {
        lipImageView.image = lipstick.lipstickImage
        lipBrandLabel.text = lipstick.lipstickBrand
        lipNameLabel.text = lipstick.lipstickName
        lipColorNameLabel.text = lipstick.lipstickColorName
        lipDetailLabel.text = lipstick.lipShortDetail
        colorUIView.backgroundColor = lipstick.lipColorCode
        
    }
 
}
