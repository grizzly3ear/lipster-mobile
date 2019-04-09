//
//  lipDetailViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 8/4/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class LipDetailVController: UIViewController {
    @IBOutlet weak var detailViewContainer: UIView!
    @IBOutlet weak var lipstickImage: UIImageView!
    @IBOutlet weak var lipSelectColor: UIButton!

    var imageOfDetail = UIImage()
    var lipClickedColor = UIImage()
    var detailView : UIView!
    var reviewView : UIView!
    var lipstick : Lipstick?
    override func viewDidLoad() {
        super.viewDidLoad()

        detailView = DetailSegmentVC().view
        reviewView = ReviewSegmentVC().view
        detailViewContainer.addSubview(detailView)
        detailViewContainer.addSubview(reviewView)
        
        if let lipstick = self.lipstick{
            self.lipstickImage.image =  lipstick.lipstickImage
        
        }
        
    }
    
    //-----------------Segment control -------------
    @IBAction func switchViewAction(_ sender: UISegmentedControl) {
        switch  sender.selectedSegmentIndex {
        case 0:
            detailViewContainer.addSubview(detailView)
            break
        case 1:
            detailViewContainer.addSubview(reviewView)
            break
        default:
            break
        }
    
    }
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
    

}
