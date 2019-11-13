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
    
    var notificationVc: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.updateBadge),
                                               name: NSNotification.Name(rawValue: NotificationEvent.updateBadge),
                                               object: nil)
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: NotificationEvent.updateBadge),
                                               object: nil,
                                               queue: nil,
                                               using: self.updateBadge)
        
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
            
            if i == 3 {
                notificationVc = uiviewController
            }
            
            uiviewControllers.append(uiviewController!)
        }
        self.tabBar.backgroundColor = .black
        self.tabBar.barTintColor = .black
        
        self.viewControllers = uiviewControllers
    }
    
    @objc func updateBadge(notification: Notification) -> Void {
        guard let badgeVal = notification.userInfo!["badge"] as? NSNumber else { return }
        
        if let tabbar = notificationVc!.tabBarItem as? ESTabBarItem {
            tabbar.badgeColor = .red
            tabbar.badgeValue = badgeVal == 0 ? nil : "\(badgeVal)"
        }
        
    }
}


