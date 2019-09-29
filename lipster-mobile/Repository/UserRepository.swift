import Foundation
import UIKit
import SwiftyJSON
import SDWebImage

class UserRepository {
    
    public static func authenticate(email: String, password: String, completion: @escaping (Int, [String]) -> Void) {
        let request = HttpRequest()
        request.post("api/login", ["email": email, "password": password], nil) { (response, httpStatusCode) -> (Void) in
            if httpStatusCode == 200 {
                let localStorage = UserDefaults.standard
                let token = response!["token"].stringValue
                localStorage.set(token, forKey: "token")
                completion(200, ["success", "Welcome"])
            } else if httpStatusCode == 500 {
                completion(500, ["Server Error", "Sorry, an unexpected error occured. Please try again later. Error code: 1"])
            } else if httpStatusCode == 401 {
                completion(401, ["Login Failed", "Sorry, your email or password are wrong. Please try again."])
            }
            
        }
    }
}
