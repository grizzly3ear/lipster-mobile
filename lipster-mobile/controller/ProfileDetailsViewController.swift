//
//  ProfileDetailsViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 11/5/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class ProfileDetailsViewController: UIViewController {
    @IBOutlet weak var profileDetailUserImageView: UIImageView!
    
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userFirstname: UILabel!
    @IBOutlet weak var userLastname: UILabel!
    @IBOutlet weak var userGender: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileDetailUserImageView.layer.cornerRadius = profileDetailUserImageView.frame.size.width / 2
        profileDetailUserImageView.clipsToBounds = true
    }
    


}
