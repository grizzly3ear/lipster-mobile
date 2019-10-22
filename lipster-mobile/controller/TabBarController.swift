//
//  TabBarController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 27/3/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit
import ESTabBarController_swift

class TabBarController: ESTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBarItem.appearance().setTitleTextAttributes(   [NSAttributedString.Key.foregroundColor: UIColor.white],
            for: .selected
        )
        
        var uiviewControllers = [UIViewController]()
        let pageArray = [
            "HomeTable",
            "Search",
            "LipColorDetection",
            "Notification",
            "Profile"
        ]
        let photoArray = [
            "home",
            "search",
            "camera",
            "noti",
            "profile"
        ]
        for i in 0 ..< pageArray.count {
            let uiviewController = storyboard?.instantiateViewController(withIdentifier: "\(pageArray[i])ViewController")
            if i == 2 {
                uiviewController!.tabBarItem = ESTabBarItem(BigBounceTabbarItem(), image: UIImage(named: photoArray[i]), selectedImage: UIImage(named: "\(photoArray[i])Now"))
            } else {
                uiviewController!.tabBarItem = ESTabBarItem(BounceTabbarItem(), image: UIImage(named: photoArray[i]), selectedImage: UIImage(named: "\(photoArray[i])Now"))
            }
            
            uiviewControllers.append(uiviewController!)
        }
        self.tabBar.backgroundColor = .black
        self.tabBar.barTintColor = .black
        
        self.viewControllers = uiviewControllers
    }
}


