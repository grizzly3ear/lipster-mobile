//
//  UIVIewController.swift
//  lipster-mobile
//
//  Created by Vitsarut Udomphol on 25/9/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func hideTabBar(_ duration: Double = 0.5) {
        var frame = self.tabBarController?.tabBar.frame
        frame?.origin.y = self.view.frame.size.height + (self.tabBarController?.tabBar.frame.size.height)!
        
        UIView.animate(
            withDuration: duration,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0,
            options: .curveLinear,
            animations: {
                self.tabBarController?.tabBar.frame = frame!
            }
        )
    }
    
    func showTabBar(_ duration: Double = 0.3, height: CGFloat = -1) {
        var frame: CGRect?
        
        if height == -1 {
            frame = self.tabBarController?.tabBar.frame
            frame?.origin.y = self.view.frame.size.height + 15
        } else {
            frame = self.tabBarController?.tabBar.frame
            frame?.origin.y = height + 15
        }
        
        
        UIView.animate(
            withDuration: duration,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 0,
            options: .curveLinear,
            animations: {
                self.tabBarController?.tabBar.frame = frame!
            }
        )
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= 260
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
