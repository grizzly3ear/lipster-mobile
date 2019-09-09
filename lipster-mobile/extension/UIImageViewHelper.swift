//
//  UIImageView.swift
//  lipster-mobile
//
//  Created by Bank on 9/5/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

extension UIImageView {
    func getPixelColor(point: CGPoint?) -> UIColor {
        guard (point != nil) else {
            return .black
        }
        let pixel = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        context!.translateBy(x: -point!.x, y: -point!.y)
        
        self.layer.render(in: context!)
        let color: UIColor = UIColor(red: CGFloat(pixel[0])/255.0,
                                     green: CGFloat(pixel[1])/255.0,
                                     blue: CGFloat(pixel[2])/255.0,
                                     alpha: 1)
        pixel.deallocate()
        return color
    }

}
