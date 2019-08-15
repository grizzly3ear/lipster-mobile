//
//  LipstickRepository.swift
//  lipster-mobile
//
//  Created by Bank on 6/8/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import SDWebImage


class LipstickRepository {
    
    public static func fetchReview(lipstickId: Int, completion: @escaping ([UserReview]) -> Void ) {
        let request = HttpRequest()
        request.get("api/lipstick/color/\(lipstickId)/reviews", nil, nil) { (response, _)  -> (Void) in
            if response == nil {
                completion([UserReview]())
            }
            completion(UserReview.makeArrayModelFromJSON(response: response))
        }
    }
    
    public static func fetchAllLipstickData(completion: @escaping ([Lipstick]) -> Void ) {
        let request = HttpRequest()
        request.get("api/brand", ["part": "detail,color"], nil) { (response, _) -> (Void) in
            if response == nil {
                completion([Lipstick]())
            }
            completion(Lipstick.makeArrayModelFromBrandJSON(response: response))
            
        }
    }
    
    public static func fetchLipstickWithSameDetail(lipstick: Lipstick, completion: @escaping ([Lipstick]) -> Void ) {
        let request = HttpRequest()
        request.get("api/lipstick/detail/\(lipstick.lipstickDetailId)", ["part": "color,brand"], nil) { (response, _) -> (Void) in
            if response == nil {
                completion([Lipstick]())
            }
            completion(Lipstick.makeArrayModelFromDetailJSON(response: response))
        }
    }
    
}
