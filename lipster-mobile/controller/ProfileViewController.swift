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
    
    var label = ["Profile Details" , "Your Favourite" , "Recently View"]
    var icon = [#imageLiteral(resourceName: "profileDeatail") , #imageLiteral(resourceName: "heart") , #imageLiteral(resourceName: "recentlyView")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileUserImageView.layer.cornerRadius = profileUserImageView.frame.size.width/2
        profileUserImageView.clipsToBounds = true
    }
    


}
extension ProfileViewController : UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
        cell.profileTitle.text = label[indexPath.row]
        cell.profileIcon.image = icon[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showProfileDetails", sender: self)
    }
  
}
