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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.layer.cornerRadius = 20
       trendGroupImage.layer.cornerRadius = 20
        trendGroupImage.clipsToBounds = true
        roundCorners(cornerRadiusButtom: 20.0)
       // blurBackground()
    }
 
    func roundCorners(cornerRadiusButtom : Double) {
    
        self.blurView.layer.cornerRadius = CGFloat(cornerRadiusButtom)
        self.clipsToBounds = true
//        self.trendGroupImage.layer.maskedCorners = [.layerMaxXMinYCorner , .layerMinXMinYCorner]
        self.blurView.layer.maskedCorners = [ .layerMinXMaxYCorner , .layerMaxXMaxYCorner]
        
    }
    func blurBackground(){
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = blurView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.addSubview(blurEffectView)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    

}
