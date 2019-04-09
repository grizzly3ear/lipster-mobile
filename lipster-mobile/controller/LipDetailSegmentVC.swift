//
//  LipDetailSegmentVC.swift
//  lipster-mobile
//
//  Created by Mainatvara on 9/4/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit
import ExpandableLabel
class LipDetailSegmentVC: UIViewController , UITextViewDelegate {
    
    @IBOutlet weak var lipstickImage: UIImageView!
    @IBOutlet weak var lipstickBrand: UILabel!
    @IBOutlet weak var lipstickName: UILabel!
    @IBOutlet weak var lipstickColorName: UILabel!
    @IBOutlet weak var lipstickShortDetail: UILabel!
    @IBOutlet weak var detailViewContainer: UIView!

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var seemore: ExpandableLabel!
    
    @IBOutlet weak var reviewTableView: UITableView!
    @IBOutlet weak var lipSelectColor: UIButton!

    @IBOutlet weak var typeReviewTextView: UITextView!
    
    
    var imageOfDetail = UIImage()
    var lipBrandofDetail = String()
    var lipNameOfDetail = String()
    var lipColorNameOfDetail = String()
    var lipAllDetail = String()
    var lipClickedColor = UIImage()
    var typeReview = UITextView()
    
    var detailView : UIView!
    var reviewView : UIView!
    
    var lipstick : Lipstick?
    override func viewDidLoad() {
        super.viewDidLoad()

        if let lipstick = self.lipstick{
            self.lipstickImage.image =  lipstick.lipstickImage
            self.lipstickBrand.text = lipstick.lipstickBrand
            self.lipstickName.text = lipstick.lipstickName
            self.lipstickColorName.text = lipstick.lipstickColorName
            self.lipstickShortDetail.text = lipstick.lipShortDetail
            
        }
        typeReviewTextView.text = "Review this lipstick here."
        typeReviewTextView.textColor = UIColor.lightGray
        typeReviewTextView.delegate = self
        typeReviewTextView.returnKeyType = .done
        
        self.userList = self.createUserArray()
        //----------------Read more / Read less--------------
        seemore.numberOfLines = 15
        seemore.collapsedAttributedLink = NSAttributedString(string: "Read More")
        seemore.expandedAttributedLink = NSAttributedString(string: "Read Less")
        seemore.setLessLinkWith(lessLink: "Close", attributes: [NSAttributedString.Key.foregroundColor:UIColor.red], position: nil)
        seemore.ellipsis = NSAttributedString(string: "...")
        seemore.collapsed = true

    }
    //-----------------------User Array------------------------
    var userList  = [UserReview] ()
    
    func createUserArray() -> [UserReview] {
        let user1 : UserReview = UserReview(userProfile: #imageLiteral(resourceName: "user2"), userReview: "REVIEWWWWWWWWWWWWWW!!!!!", userName: "BankAha Wisarut" )
        let user2 : UserReview = UserReview(userProfile: #imageLiteral(resourceName: "user1"), userReview: "nice!!!!!!!!!", userName: "Bowie Ketsara" )
        
        return [user1,user2]
    }
    
    var userReviews : [String] = ["nicccccceeeeeeeeeeeee",
                                  "love this color , should try!",
                                  "nice one."]
    
    //-----------------------------Clicked Post to Review---------------------------------
  
    @IBAction func ClickedPostReviewButton(_ sender: Any) {
        if typeReviewTextView.text!.isEmpty {
            print("Type Review, Text Field is empty")
        }
        //cell.lipNameLabel.text = lipList[indexPath.row].lipstickName
        userReviews.append(typeReviewTextView.text!)
        let indexPath = IndexPath(row: userReviews.count - 1, section: 0)
        
        reviewTableView.beginUpdates()
        reviewTableView.insertRows(at: [indexPath], with: .automatic)
        reviewTableView.endUpdates()
        
        typeReviewTextView.text = ""
        view.endEditing(true)
    }
    
    // ----------------------select LipColor and LipImage will change-------------------------
    @IBOutlet weak var lipImageColor: UIImageView!
    
    @IBAction func clickedColor(_ sender: UIButton) {
        print("clicked!!! \(sender.tag)")
        if sender.tag == 0{
            let imageClicked  = sender.image(for: .normal)
            lipImageColor.image = #imageLiteral(resourceName: "PK037")
            
        }
        if sender.tag == 1{
            let imageClicked  = sender.image(for: .normal)
            lipImageColor.image = #imageLiteral(resourceName: "BE115")
            
        }
        if sender.tag == 2{
            let imageClicked  = sender.image(for: .normal)
            lipImageColor.image = #imageLiteral(resourceName: "BE116")
            
        }
        if sender.tag == 3{
            let imageClicked  = sender.image(for: .normal)
            lipImageColor.image = #imageLiteral(resourceName: "PK037")
            
        }
        if sender.tag == 4{
            let imageClicked  = sender.image(for: .normal)
            lipImageColor.image = #imageLiteral(resourceName: "BE115")
            
        }
        
    }

    @IBAction func segments(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex{
        case 0 :
            scrollView.setContentOffset(CGPoint( x : 0 , y : 0), animated:true)
        case 1 :
            scrollView.setContentOffset(CGPoint( x : 375 , y : 0), animated:true)
            
        default:
            print("")
        }
        
    }
        //----------------------------
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
            
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text == "" {
                textView.text = "Review this lipstick here."
                textView.textColor = UIColor.lightGray
            }
        }
    }
extension LipDetailSegmentVC   : UITableViewDelegate , UITableViewDataSource{
            
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                
            return userReviews.count
                
        }
            
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
            // อาเรย์ userReview ที่เเสดงเป็น tableList
            let review = userReviews[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserReviewTableViewCell") as! UserReviewTableViewCell
                cell.userReviewLabel.text = review
            
                return cell
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
        }
}
