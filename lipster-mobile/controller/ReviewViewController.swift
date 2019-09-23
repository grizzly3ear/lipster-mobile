//
//  ReviewViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 16/9/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit
import ExpandableLabel

class ReviewViewController: UIViewController {

    @IBOutlet weak var lipstickImage: UIImageView!
    @IBOutlet weak var lipstickBrand: UILabel!
    @IBOutlet weak var lipstickColorName: UILabel!
    @IBOutlet weak var lipstickName: UILabel!
    
    @IBOutlet weak var reviewTableView: UITableView!

    @IBOutlet weak var typeReview: UITextField!
    
    var lipstick: Lipstick!
    var userReviews  = [UserReview]()
    var labelState: [Bool]!

    override func viewDidLoad() {
        super.viewDidLoad()
        initialUI()
        labelState = Array(repeating: true, count: userReviews.count)
        reviewTableView.rowHeight = UITableView.automaticDimension
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reviewTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    @IBAction func sendButton(_ sender: Any) {
        insertNewReview()
    }
    
    func insertNewReview() {
        
        if typeReview.text!.isEmpty {
            print("Add Review Text Field is empty")
        }
        
        let indexPath = IndexPath(row: userReviews.count - 1, section: 0)
        
        reviewTableView.beginUpdates()
        reviewTableView.insertRows(at: [indexPath], with: .automatic)
        reviewTableView.endUpdates()
        
        typeReview.text = ""
        view.endEditing(true)
    }

}

extension ReviewViewController: UITableViewDelegate , UITableViewDataSource, ExpandableLabelDelegate {
    
    func willExpandLabel(_ label: ExpandableLabel) {
        reviewTableView.beginUpdates()
    }
    
    func didExpandLabel(_ label: ExpandableLabel) {
        let point = label.convert(CGPoint.zero, to: reviewTableView)
        if let indexPath = reviewTableView.indexPathForRow(at: point) as IndexPath? {
            print(indexPath.row)
            labelState[indexPath.row] = false
        }
        print(point)
        reviewTableView.endUpdates()
        reviewTableView.reloadData()
    }
    
    func willCollapseLabel(_ label: ExpandableLabel) {
    }
    
    func didCollapseLabel(_ label: ExpandableLabel) {
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userReviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserReviewTableViewCell") as! UserReviewTableViewCell
        let review = userReviews[indexPath.row]
        cell.setUserReview(user: review)
        
        cell.userImage.layer.masksToBounds = true
        cell.userImage.layer.cornerRadius = 30.0
        
        cell.layoutIfNeeded()
        
        cell.userImage.layer.borderColor = UIColor.black.cgColor
        cell.userImage.layer.borderWidth = 1
        
        cell.userReviewLabel.delegate = self
        cell.userReviewLabel.numberOfLines = 2
        cell.userReviewLabel.collapsed = labelState[indexPath.row]
        cell.userReviewLabel.sizeToFit()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        reviewTableView.deselectRow(at: indexPath, animated: true)
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
