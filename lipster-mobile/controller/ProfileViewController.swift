//
//  ProfileViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 6/8/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var username: UILabel!

    @IBOutlet weak var background: UIView!
    @IBOutlet weak var editProfileButton: UIButton!
    
    
    @IBOutlet weak var favoriteLipstickView: UIView!
    @IBAction func favoriteLipstickIconButton(_ sender: Any) {
           self.performSegue(withIdentifier: "showFavoriteLipstickFromIcon", sender: self)
    }
    @IBAction func favoriteLipsickLabelButton(_ sender: Any) {
           self.performSegue(withIdentifier: "showFavoriteLipstickFromLabel", sender: self)
    }
    
    @IBAction func editProfileButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: "showEditProfile", sender: self)
    }
    
    @IBAction func recentlyViewIconButton(_ sender: Any) {
            self.performSegue(withIdentifier: "showRecentlyViewFromLabel", sender: self)
    }
    @IBAction func recentlyViewLabelButton(_ sender: Any) {
            self.performSegue(withIdentifier: "showRecentlyViewFromLabel", sender: self)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userProfileImage.layer.cornerRadius = userProfileImage.frame.size.width/2
        userProfileImage.clipsToBounds = true

        dropShadow()

        favoriteLipstickView.isUserInteractionEnabled = true

        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(clickButton))
            tapGesture.numberOfTapsRequired = 1
            favoriteLipstickView.addGestureRecognizer(tapGesture)
    }
        // MARK:- clickButton
    @objc func clickButton() {
            print(" Click favorite lipstick button")
        
    }
    
}

extension ProfileViewController{
    func dropShadow(scale: Bool = true) {
        background.layer.cornerRadius = 30
        background.layer.masksToBounds = false
        background.layer.shadowColor = UIColor.black.cgColor
        background.layer.shadowOpacity = 0.4
        background.layer.shadowOffset = .zero
        background.layer.shadowRadius = 6
        background.layer.shouldRasterize = true
        background.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
