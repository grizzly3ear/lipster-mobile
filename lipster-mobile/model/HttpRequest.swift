import Foundation
import Alamofire
import SwiftyJSON

class HttpRequest {
    
    var domain: String!
    var token: String?
    
    init(_ domain: String) {
        self.domain = domain
        self.token = ""
    }
    
    init(_ domain: String, _ token: String?) {
        self.domain = domain
        self.token = token
    }
    
    public func get(_ route: String, _ params: [String: Any]?, _ headers: [String: String]?, completion: @escaping (JSON?) -> (Void)) {
        
        Alamofire.request("\(domain!)/\(route)", method: .get, parameters: params, headers: headers).validate().responseJSON { (response) in
            
            guard response.result.isSuccess, let value = response.result.value else {
                completion(nil)
                return
            }
            
            let json = JSON(value)
            
            completion(json)
        }
    }
    
    public func post(_ route: String, _ params: [String: Any]?, _ headers: [String: String]?, completion: @escaping (JSON?) -> (Void)) {
        
        Alamofire.request("\(domain!)/\(route)", method: .post, parameters: params, headers: headers).validate().responseJSON { (response) in
            
            guard response.result.isSuccess, let value = response.result.value else {
                completion(nil)
                return
            }
            
            let json = JSON(value)
            
            completion(json)
        }
    }
    
    public func put(_ route: String, _ params: [String: Any]?, _ headers: [String: String]?, completion: @escaping (JSON?) -> (Void)) {
        
        Alamofire.request("\(domain!)/\(route)", method: .put, parameters: params, headers: headers).validate().responseJSON { (response) in
            
            guard response.result.isSuccess, let value = response.result.value else {
                completion(nil)
                return
            }
            
            let json = JSON(value)
            
            completion(json)
        }
    }
}
