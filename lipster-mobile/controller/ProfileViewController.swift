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
    
    
    @IBAction func editProfileButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: "showEditProfile", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userProfileImage.layer.cornerRadius = userProfileImage.frame.size.width/2
        userProfileImage.clipsToBounds = true

        background.layer.cornerRadius = 30
        background.layer.shadowRadius = 20
        
    }
    


}
