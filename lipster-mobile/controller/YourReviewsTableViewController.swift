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

    @IBOutlet var yourReviewedTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    @IBAction func goBack(_ sender: Any) {
        hero.dismissViewController()
    }
    
    func fetchData() {
        UserRepository.getMyReview { (userReviews, httpStatusCode) in
            if httpStatusCode == 200 {
                self.yourReviews = userReviews
                self.tableView.performBatchUpdates({
                    self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
                }) { (_) in
                }
            } else {
                // MARK: Problem
            }
        }
    }
}

extension YourReviewsTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  yourReviews.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "YourReviewsTableViewCell") as! YourReviewsTableViewCell
        
        let review = yourReviews[indexPath.row]
        
        cell.setLipstick(lipstick: review.lipstick)
        cell.setUserReview(userReviews: review)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 137
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showReview" , sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segueIdentifier = segue.identifier
        if segueIdentifier == "showReview" {
            if let destination = segue.destination as? ReviewViewController {
                let indexPath = sender as! IndexPath
                destination.lipstick = yourReviews[indexPath.row].lipstick
                destination.reviews = [yourReviews[indexPath.row]]
            }
            
        }
    }
 
}
