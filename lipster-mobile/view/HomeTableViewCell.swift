//
//  HomeTableViewCell.swift
//  lipster-mobile
//
//  Created by Mainatvara on 21/10/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var trendGroupTitle: UILabel!
    @IBOutlet weak var trendGroupDescription: UILabel!
    @IBOutlet weak var trendGroupImage: UIImageView!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var blurViewEffect: UIVisualEffectView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        blurViewEffect.layer.masksToBounds = true
        cellView.layer.cornerRadius = 20
        trendGroupImage.layer.cornerRadius = 20
        trendGroupImage.clipsToBounds = true
        roundCorners(cornerRadiusButtom: 20.0)
        blurBackground()
        dropShadow()
//        cellView.dropShadow(color: .red, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
    }
    func dropShadow(){
        let shadowSize : CGFloat = 10.0
       
        self.cellView.layer.masksToBounds = false
        self.cellView.layer.shadowColor = UIColor.black.cgColor
        self.cellView.layer.shadowOpacity = 0.4
        
    
    }
                    
    func roundCorners(cornerRadiusButtom : Double) {
    
        self.blurViewEffect.layer.cornerRadius = CGFloat(cornerRadiusButtom)
        self.clipsToBounds = true
//        self.trendGroupImage.layer.maskedCorners = [.layerMaxXMinYCorner , .layerMinXMinYCorner]
        self.blurViewEffect.layer.maskedCorners = [ .layerMinXMaxYCorner , .layerMaxXMaxYCorner]
        
    }
    func blurBackground(){
        blurViewEffect.alpha = 1

//        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = blurViewEffect.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        blurViewEffect.addSubview(blurEffectView)

       
    }
  

}
