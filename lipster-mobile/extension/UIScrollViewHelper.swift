//
//  UIScrollViewHelper.swift
//  lipster-mobile
//
//  Created by Bank on 29/4/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

extension UIScrollView {
    func currentPage() -> Int {
        return Int(self.contentOffset.x / self.frame.size.width)
    }
}
