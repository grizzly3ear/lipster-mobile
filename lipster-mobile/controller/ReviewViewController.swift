//
//  ReviewViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 16/9/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit
import ExpandableLabel
import ReactiveCocoa
import ReactiveSwift
import Result

class ReviewViewController: UIViewController {

    @IBOutlet weak var lipstickImage: UIImageView!
    @IBOutlet weak var lipstickBrand: UILabel!
    @IBOutlet weak var lipstickColorName: UILabel!
    @IBOutlet weak var lipstickName: UILabel!
    
    @IBOutlet weak var reviewTableView: UITableView!

    @IBOutlet weak var actionBackground: UIView!
    @IBOutlet weak var typeReview: UITextField!
    @IBOutlet weak var insertReviewButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    let reviewDataPipe = Signal<[UserReview], NoError>.pipe()
    var reviewDataObserver: Signal<[UserReview], NoError>.Observer?
    
    var lipstick: Lipstick!
    var userReviews  = [UserReview]()
    var labelState: [Bool]!
    
    var pageState: Bool = true

    var reviews = [UserReview]()

    override func viewDidLoad() {
        super.viewDidLoad()
        initialUI()
        typeReview.delegate = self
        reviewTableView.rowHeight = UITableView.automaticDimension
        hideTabBar()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        initReactive()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initialUI()
        reviewTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        if pageState {
//
//            showTabBar(0.3, height: 605)
//        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    @IBAction func sendButton(_ sender: Any) {
        insertNewReview()
    }
    
    func insertNewReview() {
        
        if typeReview.text!.trim().isEmpty {
            print("Add Review Text Field is empty")
        } else {
            LipstickRepository.addReview(lipstick: lipstick, comment: typeReview.text!) {result, status in

                if !result && status == 401 {
                    self.pageState = false
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    vc.redirect = "ReviewViewController"
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    self.fetchLipstickReview()
                    self.typeReview.text = ""
                    self.view.endEditing(true)
                }
                
            }
        }

    }
    
    @IBAction func goBack(_ sender: Any) {
        self.pageState = true
        hero.dismissViewController()
    }
    
    func fetchLipstickReview() {
        LipstickRepository.fetchReview(lipstickId: self.lipstick!.lipstickId) { (userReviews) in
            self.initialUI()
            self.reviewDataPipe.input.send(value: userReviews)
        }
    }
    
    @IBAction func loginPress(_ sender: Any) {
        pageState = true
        let vc = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ReviewViewController: UITableViewDelegate , UITableViewDataSource, ExpandableLabelDelegate {
    
    func willExpandLabel(_ label: ExpandableLabel) {
        reviewTableView.beginUpdates()
    }
    
    func didExpandLabel(_ label: ExpandableLabel) {
        let point = label.convert(CGPoint.zero, to: reviewTableView)
        if let indexPath = reviewTableView.indexPathForRow(at: point) as IndexPath? {
            labelState[indexPath.row] = false
        }
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
        self.labelState = Array(repeating: true, count: userReviews.count)
        self.lipstickBrand.text = lipstick.lipstickBrand
        self.lipstickImage.sd_setImage(with: URL(string: (lipstick.lipstickImage.first ?? "")), placeholderImage: UIImage(named: "nopic")!)
        self.lipstickColorName.text = lipstick.lipstickColorName
        self.lipstickName.text = lipstick.lipstickName
        
        if userReviews.count == 0 {
            self.reviewTableView.separatorStyle = .none
            self.reviewTableView.tableFooterView = UIView(frame: .zero)
            self.reviewTableView.backgroundColor = .clear
            
            let label = UILabel()
            label.frame.size.height = 42
            label.frame.size.width = self.reviewTableView.frame.size.width
            label.center = self.reviewTableView.center
            label.center.y = self.reviewTableView.frame.size.height / 2
            label.numberOfLines = 2
            label.textColor = .darkGray
            label.text = "There are no review yet."
            label.textAlignment = .center
            label.tag = 1
            
            self.reviewTableView.addSubview(label)
        } else {
            self.reviewTableView.viewWithTag(1)?.removeFromSuperview()
        }
        
        if User.isInstanceInit() {
            self.typeReview.isHidden = false
            self.insertReviewButton.isHidden = false
            self.loginButton.isHidden = true
        } else {
            self.typeReview.isHidden = true
            self.insertReviewButton.isHidden = true
            self.loginButton.isHidden = false
            
            actionBackground.bringSubviewToFront(loginButton)
            
            loginButton.layer.cornerRadius = 8.0
            
        }
        
        
    }
}

extension ReviewViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

extension ReviewViewController {
    func initReactive() {
        reviewDataObserver = Signal<[UserReview], NoError>.Observer(value: { (userReviews) in
            self.userReviews = userReviews
            
            self.reviewTableView.performBatchUpdates({
                self.initialUI()
                self.reviewTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            }) { (_) in
                
                self.reviewTableView.scrollToRow(at: IndexPath(row: self.userReviews.count - 1, section: 0), at: .bottom, animated: true)
            }
        })
        reviewDataPipe.output.observe(reviewDataObserver!)
    }
}
