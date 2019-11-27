//
//  User.swift
//  lipster-mobile
//
//  Created by Bank on 24/10/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

import Firebase

import UserNotifications

fileprivate let firstnameType = "firstname"
fileprivate let lastnameType = "lastname"
fileprivate let emailType = "email"
fileprivate let imageType = "profileImage"
fileprivate let idType = "id"
fileprivate let genderType = "gender"

class User {
    
    static let shared: User = User()
    static private var sharedUserState: Bool = false
    
    public static func isInstanceInit() -> Bool {
        return sharedUserState
    }
    
    private init() {}
    
    public static func setSingletonUser(user: User) {
        shared.email = user.email!
        shared.firstname = user.firstname!
        shared.lastname = user.lastname!
        shared.gender = user.gender!
        shared.id = user.id!
        shared.imageURL = user.imageURL!
        sharedUserState = true
        Messaging.messaging().unsubscribe(fromTopic: "non_login")
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    public static func clearSingletonUser() {
        let user = User()
        shared.email = user.email
        shared.firstname = user.firstname
        shared.lastname = user.lastname
        shared.gender = user.gender
        shared.id = user.id
        shared.imageURL = user.imageURL
        sharedUserState = false
        Messaging.messaging().subscribe(toTopic: "non_login")
    }
    
    public init(firstname: String, lastname: String, email: String, imageURL: String, id: String, gender: String) {
        self.firstname = firstname
        self.lastname = lastname
        self.email = email
        self.imageURL = imageURL
        self.id = id
        self.gender = gender
    }
    
    var firstname: String?
    
    var lastname: String?
    
    var email: String?
    
    var imageURL: String?
    
    var id: String?
    
    var gender: String?
    
    public static func isAuth(completion: @escaping (Bool) -> Void) {
        UserRepository.getUser { _, result in
            completion(result)
        }
    }
    
    public static func makeModelFromUserJSON(response: JSON?) -> User? {
        if response == nil {
            return nil
        }
        
        let id = response!["id"].stringValue
        let firstname = response!["firstname"].stringValue
        let lastname = response!["lastname"].stringValue
        let imageURL = response!["image"].stringValue
        let gender = response!["gender"].stringValue
        let email = response!["email"].stringValue
        
        return User(
            firstname: firstname,
            lastname: lastname,
            email: email,
            imageURL: imageURL,
            id: id,
            gender: gender
        )
    }
    
}
