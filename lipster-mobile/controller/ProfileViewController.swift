//
//  ProfileViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 11/5/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileUserImageView: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var profileDetailButton: UIButton!
    @IBOutlet weak var yourFavoriteButton: UIButton!
    @IBOutlet weak var recentlyViewButton: UIButton!
    
    
    @IBAction func profileDetailButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "showProfileDetail", sender: self)
    }
    @IBAction func yourFavoriteButtonPressed(_ sender: Any) {
         self.performSegue(withIdentifier: "showYourFavorite", sender: self)
    }
    @IBAction func recentlyViewButtonPressed(_ sender: Any) {
         self.performSegue(withIdentifier: "showRecentlyView", sender: self)
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileUserImageView.layer.cornerRadius = profileUserImageView.frame.size.width/2
        profileUserImageView.clipsToBounds = true
    }
    


}

