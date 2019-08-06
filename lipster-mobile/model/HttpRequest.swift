import Foundation
import Alamofire
import SwiftyJSON

class HttpRequest {
    
    var domain = "http://18.136.104.217"
    var defaultHeaders = [
        "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "token") ?? "")"
    ]
    
    public func get(_ route: String, _ params: [String: Any]?, _ headers: [String: String]?, completion: @escaping (JSON?) -> (Void)) {
        
        Alamofire.request("\(domain)/\(route)", method: .get, parameters: params, headers: defaultHeaders).validate().responseJSON { (response) in
            
            guard response.result.isSuccess, let value = response.result.value else {
                completion(nil)
                return
            }
            
            let json = JSON(value)
            
            completion(json)
        }
    }
    
    public func post(_ route: String, _ params: [String: Any]?, _ headers: [String: String]?, completion: @escaping (JSON?) -> (Void)) {
        
        Alamofire.request("\(domain)/\(route)", method: .post, parameters: params, headers: defaultHeaders).validate().responseJSON { (response) in
            
            guard response.result.isSuccess, let value = response.result.value else {
                completion(nil)
                return
            }
            
            let json = JSON(value)
            
            completion(json)
        }
    }
    
    public func put(_ route: String, _ params: [String: Any]?, _ headers: [String: String]?, completion: @escaping (JSON?) -> (Void)) {
        
        Alamofire.request("\(domain)/\(route)", method: .put, parameters: params, headers: defaultHeaders).validate().responseJSON { (response) in
            
            guard response.result.isSuccess, let value = response.result.value else {
                completion(nil)
                return
            }
            
            let json = JSON(value)
            
            completion(json)
        }
    }
}
