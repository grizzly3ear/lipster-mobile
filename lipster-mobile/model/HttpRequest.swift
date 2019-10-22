import Foundation
import Alamofire
import SwiftyJSON

class HttpRequest {
    
    var domain = "http://18.136.104.217"
//    var domain = "http://localhost:8000"
    var defaultHeaders = [
        "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "token") ?? "")"
    ]
    
    public func get(_ route: String, _ params: [String: Any]?, _ headers: [String: String]?, completion: @escaping (JSON?, Int) -> (Void)) {
        
        Alamofire.request("\(domain)/\(route)", method: .get, parameters: params, headers: defaultHeaders).validate().responseJSON { (response) in
            self.checkResponse(response: response) { (json, status) -> (Void) in
                completion(json, status)
            }
        }
    }
    
    public func post(_ route: String, _ params: [String: Any]?, _ headers: [String: String]?, completion: @escaping (JSON?, Int) -> (Void)) {
        
        Alamofire.request("\(domain)/\(route)", method: .post, parameters: params, headers: defaultHeaders).validate().responseJSON { (response) in
            self.checkResponse(response: response) { (json, status) -> (Void) in
                completion(json, status)
            }
        }
    }
    
    public func put(_ route: String, _ params: [String: Any]?, _ headers: [String: String]?, completion: @escaping (JSON?, Int) -> (Void)) {
        
        Alamofire.request("\(domain)/\(route)", method: .put, parameters: params, headers: defaultHeaders).validate().responseJSON { (response) in
            self.checkResponse(response: response) { (json, status) -> (Void) in
                completion(json, status)
            }
        }
    }
    
    func checkResponse(response: DataResponse<Any>, completion: @escaping (JSON?, Int) -> (Void)) {
        guard response.result.isSuccess, let value = response.result.value else {
            let error = response.result.error
            if let err = error as? URLError, err.code == .cannotConnectToHost || err.code == .notConnectedToInternet || err.code == .timedOut {

                completion(nil, 0)
                return
            }
            completion(nil, response.response!.statusCode)
            return
        }
        
        let json = JSON(value)
        completion(json["data"], response.response!.statusCode)
    }

}
