//
//  LipstickDetailSegmentVC.swift
//  lipster-mobile
//
//  Created by Mainatvara on 9/4/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit
import SwiftyJSON
import ReactiveCocoa
import ReactiveSwift
import Result


class LipstickDetailSegmentVC: UIViewController {
    
    @IBOutlet weak var lipstickImagesPageControl: UIPageControl!
    @IBOutlet weak var scrollLipstickImages: UIScrollView!

    @IBOutlet weak var tryMeButton: UIButton!
    
    @IBOutlet weak var contentSegmentControl: UISegmentedControl!
    @IBOutlet weak var contentScrollView: UIScrollView!
    
    @IBOutlet weak var lipstickBrand: UILabel!
    @IBOutlet weak var lipstickName: UILabel!
    @IBOutlet weak var lipstickColorName: UILabel!
    @IBOutlet weak var lipstickShortDetail: UILabel!
    @IBOutlet weak var detailViewContainer: UIView!
    
    @IBOutlet weak var reviewTableView: UITableView!
    @IBOutlet weak var typeReviewTextView: UITextView!
    @IBOutlet weak var clickedPostButton: UIButton!
    
    @IBOutlet weak var lipstickSelectColorCollectionView: UICollectionView!
    
    @IBOutlet weak var titleNavigationItem: UINavigationItem!
    
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    let reviewDataPipe = Signal<[UserReview], NoError>.pipe()
    var reviewDataObserver: Signal<[UserReview], NoError>.Observer?
    
    var reviews: [UserReview] = [UserReview]()
    var lipstick : Lipstick?
    let request = HttpRequest("http://18.136.104.217", nil)
    
    var arrayOfLipstickColor = [UIColor(rgb: 0xFA4855) ,UIColor(rgb: 0xFA4825) ,UIColor(rgb: 0xFA4255), UIColor(rgb: 0xFA4805), UIColor(rgb: 0xFA4805) , UIColor(rgb: 0xFA4855) ,UIColor(rgb: 0xFA4825) ,UIColor(rgb: 0xFA4255), UIColor(rgb: 0xFA4805), UIColor(rgb: 0xFA4805)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData(lipstickId: lipstick?.lipstickId ?? 0)
        configureReactiveReviewData()
        typeReview()
        pageController()
        clickedPostButton.isEnabled = false
        reviewTableView.backgroundView = UIImageView(image: UIImage(named: "backgroundLiplist"))
        self.titleNavigationItem.title = lipstick?.lipstickBrand
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes

        if let lipstick = self.lipstick{
            self.lipstickBrand.text = lipstick.lipstickBrand
            self.lipstickName.text = lipstick.lipstickName
            self.lipstickColorName.text = lipstick.lipstickColorName
            self.lipstickShortDetail.text = lipstick.lipstickDetail
        }
    }

    @IBAction func segments(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0 :
            contentScrollView.setContentOffset(CGPoint( x : 0 , y : 0), animated:true)
        case 1 :
            contentScrollView.setContentOffset(CGPoint( x : 375 , y : 0), animated:true)
        default:
            contentScrollView.setContentOffset(CGPoint( x : 0 , y : 0), animated:true)
        }
        
    }
    @IBAction func clickedTryMe(_ sender: Any) {
        self.performSegue(withIdentifier: "showTryMe", sender: self)
    }
    
}

// MARK: fetch data
extension LipstickDetailSegmentVC {
    func fetchData(lipstickId: Int) {
        self.request.get("api/lipstick/color/\(lipstickId)/reviews", nil, nil) { (response) -> (Void) in
            self.reviewDataPipe.input.send(value: UserReview.makeArrayModelFromJSON(response: response))
        }
    }
}

extension LipstickDetailSegmentVC: UITableViewDelegate , UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
            
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserReviewTableViewCell") as! UserReviewTableViewCell
        cell.userReviewLabel.text = reviews[indexPath.item].userReview
        cell.userNameLabel.text = reviews[indexPath.item].userName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension LipstickDetailSegmentVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Review this lipstick here." {
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
extension LipstickDetailSegmentVC {
    @IBAction func clickedPostReviewButton(_ sender: Any) {
        
//        userReviews.append(typeReviewTextView.text!)
//        let indexPath = IndexPath(row: userReviews.count - 1, section: 0)
//
//        reviewTableView.beginUpdates()
//        reviewTableView.insertRows(at: [indexPath], with: .automatic)
//        reviewTableView.endUpdates()
//
//        typeReviewTextView.text = ""
//        clickedPostButton.isEnabled = false
//        view.endEditing(true)
    }
}

// type reivew in review segment
extension LipstickDetailSegmentVC {
    func typeReview() {
        typeReviewTextView.text = "Review this lipstick here."
        typeReviewTextView.textColor = UIColor.lightGray
        typeReviewTextView.delegate = self
        typeReviewTextView.returnKeyType = .done
    }
}

// page controll to show multi Lipstick image 
extension LipstickDetailSegmentVC : UIScrollViewDelegate {
    func pageController(){
        lipstickImagesPageControl.numberOfPages = self.lipstick?.lipstickImage.count ?? 0
        for index in 0..<lipstickImagesPageControl.numberOfPages {
            frame.origin.x = scrollLipstickImages.frame.size.width * CGFloat(index)
            frame.size = scrollLipstickImages.frame.size
    
            let imgView = UIImageView(frame: frame)
            imgView.sd_setImage(with: URL(string: self.lipstick!.lipstickImage[index]), placeholderImage: UIImage(named: "nopic"))
            self.scrollLipstickImages.addSubview(imgView)
        }
        scrollLipstickImages.contentSize = CGSize(width :(scrollLipstickImages.frame.size.width * CGFloat(lipstickImagesPageControl.numberOfPages)) , height : scrollLipstickImages.frame.size.height)
        scrollLipstickImages.delegate = self
        contentScrollView.delegate = self
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == scrollLipstickImages {
            lipstickImagesPageControl.currentPage = scrollView.currentPage()
        } else if scrollView == contentScrollView {
            contentSegmentControl.selectedSegmentIndex = scrollView.currentPage()
        }
    }
}

// collectionView cell
extension LipstickDetailSegmentVC : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfLipstickColor.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectColorFromDetailCollectionViewCell", for: indexPath) as? SelectColorFromDetailCollectionViewCell
       
        cell?.selectColorView.backgroundColor = arrayOfLipstickColor[indexPath.row]
        cell?.triangleView.isHidden = true
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! SelectColorFromDetailCollectionViewCell
        cell.triangleView.isHidden = false
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SelectColorFromDetailCollectionViewCell else {return}
        cell.triangleView.isHidden = true
    }
}

extension LipstickDetailSegmentVC {
    func configureReactiveReviewData() {
        reviewDataObserver = Signal<[UserReview], NoError>.Observer(value: { (userReviews) in
            self.reviews = userReviews
            self.reviewTableView.reloadData()
            self.reviewTableView.setNeedsLayout()
        })
        reviewDataPipe.output.observe(reviewDataObserver!)
    }
}
