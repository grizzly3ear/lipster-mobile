//
//  TrendDetailViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 20/4/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class TrendDetailViewController: UIViewController {

    @IBOutlet weak var trendBigImageView: UIImageView!
   // @IBOutlet weak var trendLipColorView: UIView!
  //  @IBOutlet weak var trendSkinColorView: UIView!
    
    var trendBigImage = UIImage()
  //  var trendLipColor = UIColor()
   // var trendSkinColor = UIColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trendBigImageView.image = trendBigImage
      //  trendLipColorView.backgroundColor = trendLipColor
       // trendSkinColorView.backgroundColor = trendSkinColor
    }
}
