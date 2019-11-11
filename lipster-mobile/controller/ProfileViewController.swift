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
    @IBOutlet weak var email: UILabel!
    
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var editProfileButton: UIButton!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var authButton: UIButton!
    
    @IBAction func logoutFromIcon(_ sender: Any) {
        if User.isInstanceInit() {
            // MARK: Login
            User.clearSingletonUser()
            UserDefaults.standard.removeObject(forKey: "token")
            initUserInterface()
        } else {
            // MARK: Not Login
            let vc = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initUserInterface()
        backgroundImage.layer.cornerRadius = 30.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        showTabBar()
        tabBarController?.tabBar.isHidden = false
        initUserInterface()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFavoriteLipstick"{
            let destination = segue.destination as! LipstickListViewController
            destination.lipstickList = Lipstick.getLipstickArrayFromUserDefault(forKey: DefaultConstant.favoriteLipsticks).reversed()
                destination.customTitleString = "Your Favorite Lipstick"
        }
        if segue.identifier == "showRecentlyView"{
            let destination = segue.destination as! LipstickListViewController
            destination.lipstickList = Lipstick.getLipstickArrayFromUserDefault(forKey: DefaultConstant.lipsticksHistory).reversed()
                destination.customTitleString = "Your Recently View"
        }
        if segue.identifier == "showYourReview"{
            
               
        }
        if segue.identifier == "showFavoriteTrend"{
            let destination = segue.destination as! PinterestCollectionViewController
            let trends = Trend.getTrendArrayFromUserDefault(forKey: DefaultConstant.favoriteTrends).reversed() as [Trend]
            destination.trendGroup = TrendGroup("Favorite Trends", trends, trends.first?.image ?? "")
            
        }
    }
    
}

extension ProfileViewController {
    func initUserInterface() {
        initDropShadow()
        
        if User.isInstanceInit() {
            userProfileImage.sd_setImage(with: URL(string: User.shared.imageURL!), placeholderImage: UIImage(named: "profile-user")!)
            username.text = User.shared.firstname! + " " + User.shared.lastname!
            username.frame.size.height = 21
            email.text = User.shared.email!
            editProfileButton.isEnabled = true
            authButton.setImage(UIImage(named: "log-out"), for: .normal)
            authButton.setTitle("Logout", for: .normal)
        } else {
            // MARK: User not logins
            userProfileImage.image = UIImage(named: "profile-user")!
            username.text = "Please Login to view your profile"
            username.frame.size.height = 42
            email.text = ""
            editProfileButton.isEnabled = false
            authButton.setImage(UIImage(named: "log-in"), for: .normal)
            authButton.setTitle("Login", for: .normal)
        }
        
        userProfileImage.layer.cornerRadius = userProfileImage.frame.size.width / 2
        userProfileImage.clipsToBounds = true
    }
    
    func initDropShadow(scale: Bool = true) {
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
