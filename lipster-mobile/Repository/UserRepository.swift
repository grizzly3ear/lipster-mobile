import Foundation
import UIKit
import SwiftyJSON

class UserRepository {
    
    public static func authenticate(email: String, password: String, completion: @escaping (Int, [String]) -> Void) {
        let request = HttpRequest()
        request.post("api/login", ["email": email, "password": password], nil) { (response, httpStatusCode) -> (Void) in
            if httpStatusCode == 200 {
                let localStorage = UserDefaults.standard
                let token = response!["token"].stringValue
                localStorage.set(token, forKey: "token")
                getUser { (userModel, result) in
                    if let user = userModel {
                        User.setSingletonUser(user: user)
                    }
                    completion(200, ["success", "Welcome"])
                }
                
            } else if httpStatusCode == 500 {
                completion(500, ["Server Error", "Sorry, an unexpected error occured. Please try again later. Error code: 1"])
            } else if httpStatusCode == 401 {
                completion(401, ["Login Failed", "Sorry, your email or password are wrong. Please try again."])
            }
            
        }
    }
    
    public static func register(email: String, password: String, firstname: String, lastname: String, gender: String, imageURL: String, completion: @escaping (Bool, [String]) -> Void) {
        let request = HttpRequest()
        request.post(
            "api/register",
            [
                "email": email,
                "password": password,
                "firstname": firstname,
                "lastname": lastname,
                "gender": gender,
                "image": imageURL
            ],
            nil
        ) {response, httpStatusCode in
            if httpStatusCode == 201 {
                // MARK:Pass
                authenticate(email: email, password: password) { (status, messages) in
                    completion(true, messages)
                    return
                }
            } else if httpStatusCode == 400 {
                completion(false, ["Server Error", "Sorry, an unexpected error occured. Please try again later. Error code: 1"])
            } else if httpStatusCode == 0 {
                completion(false, ["No Internet Connection", "Make sure your device is connected to the internet"])
            } else {
                completion(false, ["Server Error", "Sorry, an unexpected error occured. Please try again later. Error code: 1"])
            }
        }
    }
    
    public static func setNotificationToken(token: String, completion: ((Bool) -> Void)?) {
        let request = HttpRequest()
        request.post("api/user/notification", ["notification_token": token], nil, requiredAuth: true) { (response, httpStatusCode) -> (Void) in
            if let closure = completion {
                if httpStatusCode == 200 {
                    // MARK: Pass
                    closure(true)
                } else {
                    closure(false)
                }
            }
            
        }
    }
    
    public static func getUser(completion: @escaping (User?, Bool) -> Void) {
        let request = HttpRequest()
        request.get("api/user", nil, nil, requiredAuth: true) { (response, httpStatusCode) -> (Void) in
            if httpStatusCode == 401 {
                completion(nil, false)
            } else {
                completion(User.makeModelFromUserJSON(response: response), true)
            }
        }
    }
    
    public static func editProfile(firstname: String, lastname: String, gender: String, image: UIImage, completion: @escaping (User?) -> Void) {
        let request = HttpRequest()
        let imageData = image.sd_imageData()
        let stringBase64 = imageData?.base64EncodedString(options: .lineLength64Characters)
        request.put(
            "api/user",
            [
                "firstname": firstname,
                "lastname": lastname,
                "gender": gender,
                "image": stringBase64!
            ],
            nil
        ) { (response, httpStatusCode) -> (Void) in
            // MARK: Do some logic
            if httpStatusCode == 401 {
                completion(nil)
            } else {
                completion(User.makeModelFromUserJSON(response: response))
            }
            
        }
    }
    
    public static func getMyReview(completion: @escaping ([UserReview], Int) -> Void) {
        let request = HttpRequest()
        request.get(
            "api/user/reviews",
            [
                "part": "detail,brand"
            ],
            nil,
            requiredAuth: true
        ) { (response, httpStatusCode) -> (Void) in
            
            if httpStatusCode == 200 {
                completion(UserReview.makeArrayModelFromUserJSON(response: response), httpStatusCode)
            } else {
                completion([UserReview](), httpStatusCode)
            }
        }
    }
    
    public static func getMyNotification(completion: @escaping ([UserNotification], Int) -> Void) {
        let request = HttpRequest()
        request.get(
            "api/notification/user",
            [
                "part": "trend_group,store"
            ],
            nil,
            requiredAuth: true
        ) { (response, httpStatusCode) -> (Void) in
            if httpStatusCode == 200 {
                completion(UserNotification.makeArrayModelFromJSON(response: response), httpStatusCode)
            } else {
                completion([UserNotification](), httpStatusCode)
            }
        }
    }
    
    public static func readNotification(notification: UserNotification, completion: ((UserNotification?) -> Void)?) {
        let request = HttpRequest()
        request.put(
            "api/notification/\(notification.id)/state",
            [
                "state": 1
            ],
            nil,
            requiredAuth: true
        ) { (response, httpStatusCode) -> (Void) in
            if let closure = completion {
                if response == nil {
                    closure(nil)
                    return
                }
                closure(UserNotification.makeModelFromJSON(response: response))
            }
        }
    }
}
