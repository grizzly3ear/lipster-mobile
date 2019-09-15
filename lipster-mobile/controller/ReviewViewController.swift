//
//  ReviewViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 16/9/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {

    @IBOutlet weak var lipstickImage: UIImageView!
    @IBOutlet weak var lipstickBrand: UILabel!
    @IBOutlet weak var lipstickColorName: UILabel!
    @IBOutlet weak var lipstickName: UILabel!
    
    @IBOutlet weak var reviewTableView: UITableView!
    @IBOutlet weak var typeReviewTextView: UITextView!
    @IBOutlet weak var clickedPostButton: UIButton!
    
    var reviews: [UserReview] = [UserReview]()
    var lipstick : Lipstick?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

}

extension ReviewViewController: UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserReviewTableViewCell") as! UserReviewTableViewCell
        cell.userReviewLabel.text = reviews[indexPath.item].userReview
        cell.userNameLabel.text = reviews[indexPath.item].userName
        cell.reviewDate.text = reviews[indexPath.item].dateReview
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension ReviewViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Write your review here." {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.trim() == "" {
            clickedPostButton.isEnabled = false
        } else {
            clickedPostButton.isEnabled = true
        }
    }
}

// Post Button Config
extension ReviewViewController {
    @IBAction func clickedPostReviewButton(_ sender: Any) {
//        
//                userReviews.append(typeReviewTextView.text!)
//                let indexPath = IndexPath(row: userReviews.count - 1, section: 0)
//        
//                reviewTableView.beginUpdates()
//                reviewTableView.insertRows(at: [indexPath], with: .automatic)
//                reviewTableView.endUpdates()
//        
//                typeReviewTextView.text = ""
//                clickedPostButton.isEnabled = false
//                view.endEditing(true)
    }
}
