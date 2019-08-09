//
//  TabBarController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 27/3/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    var tabBarItems = UITabBarItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white] , for: .selected)
        navigationController?.isNavigationBarHidden = true
        
       // UITabBar.appearance().backgroundColor = UIColor(cgColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        
    
        
//    UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.darkGray] , for: .normal)
        
        let selectImage1 = UIImage(named: "homeNow")?.withRenderingMode(.alwaysOriginal)
        let noSelectImage1 = UIImage(named: "home")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![0]
        tabBarItems.image = noSelectImage1
        tabBarItems.selectedImage = selectImage1
        
        let selectImage2 = UIImage(named: "nearbyNow")?.withRenderingMode(.alwaysOriginal)
        let noSelectImage2 = UIImage(named: "nearby")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![1]
        tabBarItems.image = noSelectImage2
        tabBarItems.selectedImage = selectImage2
        
        let selectImage3 = UIImage(named: "cameraNow")?.withRenderingMode(.alwaysOriginal)
        let noSelectImage3 = UIImage(named: "camera")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![2]
        tabBarItems.image = noSelectImage3
        tabBarItems.selectedImage = selectImage3
        
        let selectImage4 = UIImage(named: "notiNow")?.withRenderingMode(.alwaysOriginal)
        let noSelectImage4 = UIImage(named: "noti")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![3]
        tabBarItems.image = noSelectImage4
        tabBarItems.selectedImage = selectImage4
        
        let selectImage5 = UIImage(named: "profileNow")?.withRenderingMode(.alwaysOriginal)
        let noSelectImage5 = UIImage(named: "profile")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![4]
        tabBarItems.image = noSelectImage5
        tabBarItems.selectedImage = selectImage5
        
        let numberOfTab = CGFloat((tabBar.items?.count)!)
        let tabBarSize = CGSize(width: tabBar.frame.width / numberOfTab, height: tabBar.frame.height)        
//        let tabBarColor = CGColor(colorSpace: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) as! CGColorSpace, components: )
      //  tabBar.selectionIndicatorImage = UIImage.imageWithColor(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), size: tabBarSize)
        
        self.selectedIndex = 0
    }
}


