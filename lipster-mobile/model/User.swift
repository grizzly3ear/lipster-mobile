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
fileprivate let idType = "id"

class User {
    
    static var firstname: String? {
        set {
            if let val = newValue {
                UserDefaults.standard.set(val, forKey: firstnameType)
                
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
                
            }
        }
        get {
            return UserDefaults.standard.string(forKey: imageType) ?? ""
        }
        
    }
    
    static var id: String? {
        set {
            if let val = newValue {
                UserDefaults.standard.set(val, forKey: idType)
                
            }
        }
        get {
            return UserDefaults.standard.string(forKey: idType) ?? ""
        }
    }
    
}
