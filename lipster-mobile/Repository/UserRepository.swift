import Foundation
import UIKit
import SwiftyJSON
import SDWebImage

class UserRepository {
    
    public static func authenticate(email: String, password: String, completion: @escaping () -> Void) {
        let request = HttpRequest()
        request.post("api/login", ["email": email, "password": password], nil) { (response) -> (Void) in
            let localStorage = UserDefaults.standard
            let token = response!["token"].stringValue
            localStorage.set(token, forKey: "token")
            completion()
        }
    }
}
