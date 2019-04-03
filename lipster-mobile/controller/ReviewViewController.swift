//
//  ReviewViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 2/4/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class ReviewViewController:  UITableViewController {

    
    @IBOutlet var userListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userList = self.createUserArray()
        
    }
    
    var userList = [UserReview] ()
    
    func createUserArray() -> [UserReview] {
        let user1 : UserReview = UserReview(userProfile: #imageLiteral(resourceName: "user2"), userReview: "REVIEWWWWWWWWWWWWWW!!!!!", userName: "BankAha Wisarut" )
        let user2 : UserReview = UserReview(userProfile: #imageLiteral(resourceName: "user1"), userReview: "nice!!!!!!!!!", userName: "Bowie Ketsara" )
        
        return [user1,user2]
    }




    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return userList.count
    
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "UserReviewTableViewCell") as! UserReviewTableViewCell
        cell.setUserReview(user: userList[indexPath.row])
    
    return cell
    }
}
