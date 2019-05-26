//
//  UITextFieldHelper.swift
//  lipster-mobile
//
//  Created by Bank on 26/5/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

extension UITextField {
    func setIcon(image : UIImage) {
        let iconView =  UIImageView(frame: CGRect(x: 10, y: 5, width: 20, height: 20))
        iconView.image = image
        
        let iconContainerView: UIView = UIView(frame: CGRect(x: 20, y: 0, width: 30, height: 30))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }
}
