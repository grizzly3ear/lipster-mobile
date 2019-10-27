//
//  YourReviewedTableViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 9/8/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class YourReviewsTableViewController: UITableViewController {

    var yourReviews: [UserReview] = [UserReview]()
    var yourLipsticks = [Lipstick]()

    var resultController = UITableViewController()

    @IBOutlet var yourReviewedTableView: UITableView!
    
    func createReviewedLipstickArray() -> [UserReview] {
        let review1: UserReview = UserReview(userProfile: UIImage(named: "user1")!, userReview: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s standard dummy ", userName: "Maiiiiiiii", dateReview: "2 Aug,2019  13:50")
        let review2: UserReview = UserReview(userProfile: UIImage(named: "user2")!, userReview: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s standard dummy ", userName: "Natwaraaa", dateReview: "2 Aug,2019  13:50")
        let review3: UserReview = UserReview(userProfile: UIImage(named: "user1")!, userReview: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s standard dummy ", userName: "Maii", dateReview: "2 Aug,2019  13:50")
        let review4: UserReview = UserReview(userProfile: UIImage(named: "user2")!, userReview: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry’s standard dummy ", userName: "Natwarrrrrrr", dateReview: "2 Aug,2019  13:50")

        return [review1, review2, review3, review4]
    }
    
    func createLipstickArray() -> [Lipstick] {
        let lipstick1: Lipstick = Lipstick(111, ["nopic"], "ETUDE", "Colorful Tattoo Tint", "VE222", "dffvweeeeeeee", .gray, 225)
        let lipstick2: Lipstick = Lipstick(111, ["BE115"], "MAMONDE", "Creamy Tint Color Balm Intense", "No.22", "dffvweeeeeeee",  .gray, 225)
        let lipstick3: Lipstick = Lipstick(111, ["BE116"], "MAMONDE", "Creamy Tint Squeeze Lip", "11 Happiness", "dffvweeeeeeee", .gray, 225)
        let lipstick4: Lipstick = Lipstick(111, ["BE115" , "BE116"], "MAMONDE", "ddewe", "VE222", "dffvweeeeeeee", .gray, 225)

        return [lipstick1, lipstick2, lipstick3, lipstick4]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.yourReviews  = self.createReviewedLipstickArray()
        self.yourLipsticks = self.createLipstickArray()
   
    }
    @IBAction func goBack(_ sender: Any) {
        hero.dismissViewController()
    }
}

extension YourReviewsTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  yourLipsticks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "YourReviewsTableViewCell") as! YourReviewsTableViewCell
        let lipstick = yourLipsticks[indexPath.item]
        cell.setLipstick(lipstick: lipstick)
        let review = yourReviews[indexPath.item]
        cell.setUserReview(userReviews: review)

        //  cell.lipBrandLabel.text = brand[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 235
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //   performSegue(withIdentifier: "showLipstickDetail" , sender: self)
    }
 
}
