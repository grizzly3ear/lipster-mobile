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

    
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var userFirstname: UITextField!
    @IBOutlet weak var userLastname: UITextField!
    
    

    @IBAction func yourFavoriteButtonPressed(_ sender: Any) {
         self.performSegue(withIdentifier: "showYourFavorite", sender: self)
    }
    @IBAction func recentlyViewButtonPressed(_ sender: Any) {
         self.performSegue(withIdentifier: "showRecentlyView", sender: self)
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
            self.navigationItem.title = "Profile"
        UINavigationBar.appearance().tintColor = UIColor.white
      
        profileUserImageView.layer.cornerRadius = profileUserImageView.frame.size.width/2
        profileUserImageView.clipsToBounds = true
    
    
    var getUserEmail = "janatvara@gmail.com"
    var getUsername = "mmaimmaii"
    var getFirstname = "Natwara"
    var getLastname = "Jaratvithitpong"
    
    
    username.text = getUsername
    username.clearButtonMode = .whileEditing
    userFirstname.text = getFirstname
    userFirstname.clearButtonMode = .whileEditing
    userLastname.text = getLastname
    userLastname.clearButtonMode = .whileEditing
    userEmail.text = getUserEmail
    userEmail.clearButtonMode = .whileEditing
    

}

}

