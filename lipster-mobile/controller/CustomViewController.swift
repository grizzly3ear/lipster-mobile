//
//  CustomViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 13/9/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit
import MXSegmentedControl

class CustomViewController: UIViewController {

    @IBOutlet weak var segmentedControl3: MXSegmentedControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       

        segmentedControl3.append(title: "How to").set(title: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1) , for: .selected)
        segmentedControl3.append(title: "Ingredient").set(title: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), for: .selected)

      //  segmentedControl3.indicator.boxView.alpha = 0.1
        
        segmentedControl3.addTarget(self, action: #selector(changeIndex(segmentedControl:)), for: .valueChanged)
       
    }
    
    @objc func changeIndex(segmentedControl: MXSegmentedControl) {
        
        if let segment = segmentedControl.segment(at: segmentedControl.selectedIndex) {
            segmentedControl.indicator.boxView.backgroundColor = segment.titleColor(for: .selected)
            segmentedControl.indicator.lineView.backgroundColor = segment.titleColor(for: .selected)
        }
    }
    
}

