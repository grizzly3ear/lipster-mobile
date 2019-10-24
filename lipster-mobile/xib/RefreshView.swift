//
//  RefreshView.swift
//  lipster-mobile
//
//  Created by Mainatvara on 24/10/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class RefreshView: UIView {

    var blackView : UIView!

    @IBOutlet weak var contentView: UIView!
    
  
}

extension RefreshView {
    
    
       func startAnimation() {
           UIView.animate(withDuration: 1.0, delay: 0.0, options: [.autoreverse, .repeat], animations: {
               self.blackView.frame.origin.x = 100
           }, completion: nil)
       }
       
       func stopAnimation() {
           blackView.layer.removeAllAnimations()
           blackView = nil
       }
}
