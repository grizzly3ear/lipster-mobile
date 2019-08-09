//
//  FavoriteLipstickTableViewCell.swift
//  lipster-mobile
//
//  Created by Mainatvara on 8/8/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit


class FavoriteLipstickTableViewCell: UITableViewCell {
    @IBOutlet weak var lipstickImageView: UIImageView!
    @IBOutlet weak var lipBrandLabel: UILabel!
    @IBOutlet weak var lipstickNameLabel: UILabel!
    @IBOutlet weak var lipstickColorNameLabel: UILabel!
    @IBOutlet weak var lipstickDetailLabel: UILabel!
    @IBOutlet weak var colorUIView: UIView!
    
    @IBOutlet weak var favButton: UIButton!
    
    func setLipstick(lipstick : Lipstick) {
        lipstickImageView.sd_setImage(with: URL(string: lipstick.lipstickImage.first ?? ""), placeholderImage: UIImage(named: "nopic"))
        lipBrandLabel.text = lipstick.lipstickBrand
        lipstickNameLabel.text = lipstick.lipstickName
        lipstickColorNameLabel.text = lipstick.lipstickColorName
        lipstickDetailLabel.text = lipstick.lipstickDetail
        colorUIView.backgroundColor = lipstick.lipstickColor
    }
}
