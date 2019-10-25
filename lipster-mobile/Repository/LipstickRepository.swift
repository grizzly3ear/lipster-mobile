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
    
    public static func addReview(lipstick: Lipstick, comment: String, completion: @escaping (Bool, Int) -> Void) {
        let request = HttpRequest()
        request.post(
            "api/lipstick/color/\(lipstick.lipstickId)/reviews",
            [
                "comment": comment,
                "rating": 5,
            ],
            nil,
            requiredAuth: true
        ) { (response, status) -> (Void) in
            if response == nil {
                completion(false, status)
                return
            }
            completion(true, status)
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
    
    public static func fetchSimilarLipstickHexColor(_ hex: String, completion: @escaping ([Lipstick]) -> Void ) {
        let request = HttpRequest()
        request.get("api/lipstick/color/rgb/\(hex)", ["part": "detail,brand"], nil) { (resposne, _) -> (Void) in
            completion(Lipstick.makeArrayModelFromColorJSON(response: resposne))
        }
    }

    
    
    
}
