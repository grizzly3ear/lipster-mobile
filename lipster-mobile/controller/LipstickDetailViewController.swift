//
//  LipstickDetailViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 13/3/2562 BE.
//  Copyright © 2562 Mainatvara. All rights reserved.
//

import UIKit

class LipstickDetailViewController: UIViewController {
    
    @IBOutlet weak var lipstickImage: UIImageView!
    @IBOutlet weak var lipstickBrand: UILabel!
    @IBOutlet weak var lipstickName: UILabel!
    @IBOutlet weak var lipstickColorName: UILabel!
    @IBOutlet weak var lipstickShortDetail: UILabel!
    
    @IBOutlet weak var lipstickReviews: UILabel!
    
    
    var imageOfDetail = UIImage()
    var lipBrandofDetail = String()
    var lipNameOfDetail = String()
    var lipColorNameOfDetail = String()
    var lipAllDetail = String()
    
    var lipstick : Lipstick?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        self.title = "LIPSTICK DETAIL"

        if let lipstick = self.lipstick{
            self.lipstickImage.image =  lipstick.lipstickImage
            self.lipstickBrand.text = lipstick.lipstickBrand
            self.lipstickName.text = lipstick.lipstickName
            self.lipstickColorName.text = lipstick.lipstickColorName
            self.lipstickShortDetail.text = lipstick.lipShortDetail
            
            //   self.lipstickReviews.text = lipstick.
        }
      
  
    }
    
    
}

