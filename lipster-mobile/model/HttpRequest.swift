//
//  HttpRequest.swift
//  lipster-mobile
//
//  Created by Bank on 25/4/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class HttpRequest {
    
    var domain: String!
    var token: String!
    
    init(_ domain: String) {
        self.domain = domain
        self.token = ""
    }
    
    init(_ domain: String, _ token: String) {
        self.domain = domain
        self.token = token
    }
    
    public func get(_ route: String, _ params: [String: Any]?, _ header: [String: String]?, completion: @escaping (JSON?) -> (Void)) {
        
        guard let url = URL(string: "\(domain)/\(route)") else {
            completion(nil)
            return
        }
        
        Alamofire.request(url, method: .get, parameters: params, headers: header).validate().responseJSON { (response) in
            
            guard response.result.isSuccess else {
                completion(nil)
                return
            }
            
            guard let json = try? JSON(response.data) else {
                completion(nil)
                return
            }
            
            completion(json)
        }
    }
    
    public func post(_ route: String, _ params: [String: Any]?, _ header: [String: String]?, completion: @escaping (JSON?) -> (Void)) {
        
        guard let url = URL(string: "\(domain)/\(route)") else {
            completion(nil)
            return
        }
        
        Alamofire.request(url, method: .post, parameters: params, headers: header).validate().responseJSON { (response) in
            
            guard response.result.isSuccess else {
                completion(nil)
                return
            }
            
            guard let json = try? JSON(response.data) else {
                completion(nil)
                return
            }
            
            completion(json)
        }
    }
    
    public func put(_ route: String, _ params: [String: Any]?, _ header: [String: String]?, completion: @escaping (JSON?) -> (Void)) {
        
        guard let url = URL(string: "\(domain)/\(route)") else {
            completion(nil)
            return
        }
        
        Alamofire.request(url, method: .put, parameters: params, headers: header).validate().responseJSON { (response) in
            
            guard response.result.isSuccess else {
                completion(nil)
                return
            }
            
            guard let json = try? JSON(response.data) else {
                completion(nil)
                return
            }
            
            completion(json)
        }
    }
}
