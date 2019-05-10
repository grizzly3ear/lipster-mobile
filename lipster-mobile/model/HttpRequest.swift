//
//  HttpRequest.swift
//  lipster-mobile
//
//  Created by Bank on 25/4/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
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
    
    public func get(_ route: String, _ params: [String: Any]?, _ header: [String: String]?, completion: @escaping (JSON?) -> (Void)) {
        Alamofire.request("\(domain!)/\(route)", method: .get, parameters: params, headers: header).validate().responseJSON { (response) in
            
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
    
    public func getImage(_ urlSource: String, _ params: [String: Any]?, _ header: [String: String]?, completion: @escaping (UIImage?) -> (Void)) {
        
        guard let url = URL(string: urlSource) else {
            completion(nil)
            return
        }
        
        Alamofire.request("\(url)").validate().responseImage { (response) in
            guard response.result.isSuccess else {
                completion(nil)
                return
            }
            
            if let image = response.result.value {
                let uiImage = image.af_imageAspectScaled(toFill: CGSize(width: 150, height: 150))
                completion(uiImage)
            }
            
            completion(nil)
        }
    }
    
    public func post(_ route: String, _ params: [String: Any]?, _ header: [String: String]?, completion: @escaping (JSON?) -> (Void)) {
        
        Alamofire.request("\(domain!)/\(route)", method: .post, parameters: params, headers: header).validate().responseJSON { (response) in
            
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
        
        Alamofire.request("\(domain!)/\(route)", method: .put, parameters: params, headers: header).validate().responseJSON { (response) in
            
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
