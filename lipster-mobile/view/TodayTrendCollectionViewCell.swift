//
//  todayTrendCollectionViewCell.swift
//  lipster-mobile
//
//  Created by Mainatvara on 25/10/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class TodayTrendCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cellView: UIView!
        @IBOutlet weak var trendGroupTitle: UILabel!
        @IBOutlet weak var trendGroupImage: UIImageView!
        @IBOutlet weak var blurView: UIView!
        @IBOutlet weak var blurViewEffect: UIVisualEffectView!
        
        var trendGroup: TrendGroup? {
            didSet {
                trendGroupTitle.text = trendGroup?.name
                trendGroupImage.sd_setImage(with: URL(string: trendGroup!.image!), placeholderImage: UIImage(named: "nopic"))
                trendGroupImage.contentMode = .scaleAspectFill
    //            trendGroupDescription.text = trendGroup?.trendDescription
            }
        }
        
        
        override func awakeFromNib() {
            super.awakeFromNib()
            blurViewEffect.layer.masksToBounds = true
            cellView.layer.cornerRadius = 20
            trendGroupImage.layer.cornerRadius = 20
            trendGroupImage.clipsToBounds = true
            roundCorners(cornerRadiusButtom: 20.0)
            blurBackground()
            dropShadow()
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
            self.blurViewEffect.layer.maskedCorners = [ .layerMinXMaxYCorner , .layerMaxXMaxYCorner]
            
        }
        func blurBackground(){
            blurViewEffect.alpha = 1
           
        }
      

    }

