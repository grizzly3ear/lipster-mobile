//
//  User.swift
//  lipster-mobile
//
//  Created by Bank on 24/10/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import Foundation
import UIKit

fileprivate let firstnameType = "firstname"
fileprivate let lastnameType = "lastname"
fileprivate let emailType = "email"
fileprivate let imageType = "profileImage"

class User {
    
    static var firstname: String? {
        set {
            if let val = newValue {
                UserDefaults.standard.set(val, forKey: firstnameType)
                print("firstname set: \(val)")
            }
        }
        get {
            return UserDefaults.standard.string(forKey: firstnameType) ?? ""
        }
        
    }
    
    static var lastname: String? {
        set {
            if let val = newValue {
                UserDefaults.standard.set(val, forKey: lastnameType)
                print("lastname set: \(val)")
            }
        }
        get {
            return UserDefaults.standard.string(forKey: lastnameType) ?? ""
        }
        
    }
    
    static var email: String? {
        set {
            if let val = newValue {
                UserDefaults.standard.set(val, forKey: emailType)
                print("email set: \(val)")
            }
        }
        get {
            return UserDefaults.standard.string(forKey: emailType) ?? ""
        }
        
    }
    
    static var imageURL: String? {
        set {
            if let val = newValue {
                UserDefaults.standard.set(val, forKey: imageType)
                print("image set: \(val)")
            }
        }
        get {
            return UserDefaults.standard.string(forKey: imageType) ?? ""
        }
        
    }
    
}
