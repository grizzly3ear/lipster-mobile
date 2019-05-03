//
//  TriangleView.swift
//  lipster-mobile
//
//  Created by Bank on 3/5/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class TriangleView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        
        let myBezier = UIBezierPath()
        myBezier.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        myBezier.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        myBezier.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        myBezier.close()
        myBezier.lineWidth = 2.0
        UIColor.black.setStroke()
        myBezier.stroke()
        UIColor.white.setFill()
        myBezier.fill()

//        guard let context = UIGraphicsGetCurrentContext() else { return }
//
//        context.beginPath()
//        context.move(to: CGPoint(x: rect.minX, y: rect.maxY))
//        context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
//        context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
//        context.closePath()
//
//        context.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//        context.fillPath()
//
//        context.setStrokeColor(UIColor.black.cgColor)
//        context.strokePath()
        
    }
}
