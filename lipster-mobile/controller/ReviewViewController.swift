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

    @IBOutlet weak var typeReview: UITextField!
    
    var lipstick: Lipstick!


    override func viewDidLoad() {
        super.viewDidLoad()
        initialUI()
    }
    @IBAction func sendButton(_ sender: Any) {
        insertNewReview()
        
    }
    
    var userReviews  = [UserReview]()

    func insertNewReview() {
        
        if typeReview.text!.isEmpty {
            print("Add Review Text Field is empty")
        }
        //cell.lipNameLabel.text = lipList[indexPath.row].lipstickName
     //   userReviews.append(typeReview.text!)
        let indexPath = IndexPath(row: userReviews.count - 1, section: 0)
        
        reviewTableView.beginUpdates()
        reviewTableView.insertRows(at: [indexPath], with: .automatic)
        reviewTableView.endUpdates()
        
        typeReview.text = ""
        view.endEditing(true)
    }

}

extension ReviewViewController: UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userReviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserReviewTableViewCell") as! UserReviewTableViewCell
        let review = userReviews[indexPath.row]
        cell.setUserReview(user: review)
       // cell.userReviewLabel.text = review
//        cell.userReviewLabel.text = reviews[indexPath.item].userReview
//        cell.userNameLabel.text = reviews[indexPath.item].userName
//        cell.reviewDate.text = reviews[indexPath.item].dateReview
        cell.userImage.layer.masksToBounds = true
        cell.userImage.layer.cornerRadius = 30.0
        

        cell.userImage.layer.borderColor = UIColor.black.cgColor
        cell.userImage.layer.borderWidth = 1
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension ReviewViewController {
    func initialUI() {
        self.lipstickBrand.text = lipstick.lipstickBrand
        self.lipstickImage.sd_setImage(with: URL(string: (lipstick.lipstickImage.first ?? "")), placeholderImage: UIImage(named: "nopic")!)
        self.lipstickColorName.text = lipstick.lipstickColorName
        self.lipstickName.text = lipstick.lipstickName
    }
}
