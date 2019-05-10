//
//  EditProfileImage.swift
//  lipster-mobile
//
//  Created by Mainatvara on 11/5/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class EditProfileImageView: UIView {
    
    var semiCircleLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if semiCircleLayer == nil {
            let arcCenter = CGPoint(x: bounds.size.width/2, y: bounds.size.height / 2)
            let circleRadius = bounds.size.width / 2
            let circlePath = UIBezierPath(arcCenter: arcCenter, radius: circleRadius, startAngle: CGFloat.pi, endAngle: CGFloat.pi * 2, clockwise: false)
            
            semiCircleLayer = CAShapeLayer()
            semiCircleLayer.path = circlePath.cgPath
            semiCircleLayer.fillColor = UIColor.white.cgColor
            layer.addSublayer(semiCircleLayer)
            
            // Make the view color transparent
            backgroundColor = UIColor.clear
        }
    }
    
}
