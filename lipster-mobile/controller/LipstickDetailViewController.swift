//
//  LipstickDetailViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 13/3/2562 BE.
//  Copyright © 2562 Mainatvara. All rights reserved.
//

import UIKit

class LipstickDetailViewController: UIViewController  ,  UITextFieldDelegate {
    
    @IBOutlet weak var lipstickImage: UIImageView!
    @IBOutlet weak var lipstickBrand: UILabel!
    @IBOutlet weak var lipstickName: UILabel!
    @IBOutlet weak var lipstickColorName: UILabel!
    @IBOutlet weak var lipstickShortDetail: UILabel!
    
    @IBOutlet weak var reviewTableView: UITableView!
    @IBOutlet weak var lipSelectColor: UIButton!
    
    @IBOutlet weak var typeReview: UITextField!
    
    @IBOutlet weak var lipstickReviews: UILabel!
    
    
    var imageOfDetail = UIImage()
    var lipBrandofDetail = String()
    var lipNameOfDetail = String()
    var lipColorNameOfDetail = String()
    var lipAllDetail = String()
    var lipClickedColor = UIImage()
    
    var lipstick : Lipstick?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        if let lipstick = self.lipstick{
            self.lipstickImage.image =  lipstick.lipstickImage
            self.lipstickBrand.text = lipstick.lipstickBrand
            self.lipstickName.text = lipstick.lipstickName
            self.lipstickColorName.text = lipstick.lipstickColorName
            self.lipstickShortDetail.text = lipstick.lipShortDetail
            
            //   self.lipstickReviews.text = lipstick.
        }
         self.userList = self.createUserArray()
  
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
    func insertNewReview() {
        
    }
    @IBAction func ClickedPostReviewButton(_ sender: Any) {
        if typeReview.text!.isEmpty {
            print("Type Review, Text Field is empty")
        }
        //cell.lipNameLabel.text = lipList[indexPath.row].lipstickName
        userReviews.append(typeReview.text!)
        let indexPath = IndexPath(row: userReviews.count - 1, section: 0)
        
        reviewTableView.beginUpdates()
        reviewTableView.insertRows(at: [indexPath], with: .automatic)
        reviewTableView.endUpdates()
        
        typeReview.text = ""
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
        
    }
}
extension LipstickDetailViewController : UITableViewDelegate , UITableViewDataSource {

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

