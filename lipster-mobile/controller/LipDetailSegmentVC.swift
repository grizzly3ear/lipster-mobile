//
//  LipDetailSegmentVC.swift
//  lipster-mobile
//
//  Created by Mainatvara on 9/4/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit
import ExpandableLabel


class LipDetailSegmentVC: UIViewController {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollLipImg: UIScrollView!
    @IBOutlet weak var lipstickImage: UIImageView!

    @IBOutlet weak var tryMeButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var lipstickBrand: UILabel!
    @IBOutlet weak var lipstickName: UILabel!
    @IBOutlet weak var lipstickColorName: UILabel!
    @IBOutlet weak var lipstickShortDetail: UILabel!
    @IBOutlet weak var detailViewContainer: UIView!
    @IBOutlet weak var seemore: ExpandableLabel!
    
    @IBOutlet weak var reviewTableView: UITableView!
    @IBOutlet weak var typeReviewTextView: UITextView!
    @IBOutlet weak var clickedPostButton: UIButton!
    
    
    @IBOutlet weak var lipstickSelectColorCollectionView: UICollectionView!
    
    
    var imageOfDetail = UIImage()
    var lipBrandofDetail = String()
    var lipNameOfDetail = String()
    var lipColorNameOfDetail = String()
    var lipAllDetail = String()
    var lipClickedColor = UIImage()
   
    var reviewTblView = UITableView()
    var detailView : UIView!
    var reviewView : UIView!
    var lipstickList : Lipstick?
    
    //---------------------- page control----------------------
 //   var imgPageControl : [String] = ["BE115","BE115_pic2"]
//    var imgPageControl : [String]
    var frame = CGRect(x:0,y:0,width:0 , height:0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        typeReview()
        pageController()
        self.userList = self.createUserArray()
        clickedPostButton.isEnabled = false
        reviewTableView.backgroundView = UIImageView(image: UIImage(named: "backgroundLiplist"))

        if let lipstick = self.lipstickList{
            self.lipstickImage.image =  lipstick.lipstickImage[0]
            self.lipstickImage.image =  lipstick.lipstickImage[1]
            self.lipstickBrand.text = lipstick.lipstickBrand
            self.lipstickName.text = lipstick.lipstickName
            self.lipstickColorName.text = lipstick.lipstickColorName
            self.lipstickShortDetail.text = lipstick.lipShortDetail
        }
        
        //----------------Read more / Read less--------------
        seemore.delegate = self as? ExpandableLabelDelegate
        seemore.numberOfLines = 3
        seemore.collapsed = true
        seemore.collapsedAttributedLink = NSAttributedString(string: "Read More")
        seemore.expandedAttributedLink = NSAttributedString(string: "Read Less")
        //seemore.setLessLinkWith(lessLink: "Close", attributes: [NSAttributedString.Key.foregroundColor:UIColor.red], position: nil)
        seemore.ellipsis = NSAttributedString(string: "...")
        
    }
  
    //-----------------------User Array------------------------
    var userReviews : [String] = ["nicccccceeeeeeeeeeeee",
                                  "love this color , should try!",
                                  "nice one."]
    
    var userList  = [UserReview] ()
    func createUserArray() -> [UserReview] {
        let user1 : UserReview = UserReview(userProfile: #imageLiteral(resourceName: "user2"), userReview: "REVIEWWWWWWWWWWWWWW!!!!!", userName: "BankAha Wisarut" )
        let user2 : UserReview = UserReview(userProfile: #imageLiteral(resourceName: "user1"), userReview: "nice!!!!!!!!!", userName: "Bowie Ketsara" )
        
        return [user1,user2]
    }
    
    // ----------------------select LipColor and LipImage will change-------------------------
    @IBOutlet weak var lipImageColor: UIImageView!
    @IBOutlet weak var selectColorButton: UIButton!
    @IBAction func clickedColor(_ sender: UIButton) {
        print("clicked!!! \(sender.tag)")
        
        if sender.tag == 0{
            let imageClicked  = sender.image(for: .normal)
           
            
        }

        if sender.tag == 1{
            let imageClicked  = sender.image(for: .normal)
          
        }
        if sender.tag == 2{
            let imageClicked  = sender.image(for: .normal)
            
            
        }
        if sender.tag == 3{
            let imageClicked  = sender.image(for: .normal)
        
        }
        if sender.tag == 4{
            let imageClicked  = sender.image(for: .normal)
           
        }
    }

    @IBAction func segments(_ sender: UISegmentedControl) {
        print ("Clicked segment")
        switch sender.selectedSegmentIndex{
        case 0 :
            scrollView.setContentOffset(CGPoint( x : 0 , y : 0), animated:true)
        case 1 :
            scrollView.setContentOffset(CGPoint( x : 375 , y : 0), animated:true)
            
        default:
            print("")
        }
        
    }
    @IBAction func clickedTryMe(_ sender: Any) {
        print("clicked TRY ME")
        self.performSegue(withIdentifier: "showTryMe", sender: self)
    }
   
}

extension LipDetailSegmentVC   : UITableViewDelegate , UITableViewDataSource {
  
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

extension LipDetailSegmentVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Review this lipstick here." {
            print("typing review")
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
extension LipDetailSegmentVC {
    @IBAction func clickedPostReviewButton(_ sender: Any) {
        
        //cell.lipNameLabel.text = lipList[indexPath.row].lipstickName
        userReviews.append(typeReviewTextView.text!)
        let indexPath = IndexPath(row: userReviews.count - 1, section: 0)
        
        reviewTableView.beginUpdates()
        reviewTableView.insertRows(at: [indexPath], with: .automatic)
        reviewTableView.endUpdates()
        
        typeReviewTextView.text = ""
        clickedPostButton.isEnabled = false
        view.endEditing(true)
    }
}

//scrollView of lipImg method
extension LipDetailSegmentVC {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var pageNumber = scrollLipImg.contentOffset.x / scrollLipImg.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }
}

// type reivew in review segment
extension LipDetailSegmentVC {
    func typeReview() {
        typeReviewTextView.text = "Review this lipstick here."
        typeReviewTextView.textColor = UIColor.lightGray
        typeReviewTextView.delegate = self
        typeReviewTextView.returnKeyType = .done
    }
}

// page controll to show multi Lipstick image 
extension LipDetailSegmentVC : UIScrollViewDelegate {
    func pageController(){
        pageControl.numberOfPages = (self.lipstickList?.lipstickImage.count)!
        for index in 0..<pageControl.numberOfPages {
            frame.origin.x = scrollLipImg.frame.size.width * CGFloat(index)
            frame.size = scrollLipImg.frame.size
    
            let imgView = UIImageView(frame: frame)
            imgView.image = self.lipstickList!.lipstickImage[index]
            self.scrollLipImg.addSubview(imgView)
        }
        scrollLipImg.contentSize = CGSize(width :(scrollLipImg.frame.size.width * CGFloat(pageControl.numberOfPages)) , height : scrollLipImg.frame.size.height)
        scrollLipImg.delegate = self
    }
}

extension LipDetailSegmentVC : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  10
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("collection view cell ")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectColorFromDetailCollectionViewCell", for: indexPath) as? SelectColorFromDetailCollectionViewCell
        cell?.clickedLipstickColorButton.backgroundColor = .red
       // cell.trendHomeImageView.image = trendGroup.trendList![indexPath.row].trendImage
        return cell!
    }
    
    
}
