import Foundation
import UIKit
import SwiftyJSON
import SDWebImage

class TrendRepository {
    
    public static func fetchAllTrendData(completion: @escaping ([TrendGroup], Int) -> Void) {
        let request = HttpRequest()
        request.get("api/trend/collection", ["part": "trend"], nil) { (response, status) -> (Void) in
            if response == nil {
                completion([TrendGroup](), 0)
            }
            completion(TrendGroup.makeArrayModelFromJSON(response: response), 200)
        } 
    }
    
    public static func fetchSimilarTrendLipstick(_ lipstick: Lipstick, completion: @escaping ([Trend]) -> Void) {
        let request = HttpRequest()
        request.get("api/lipstick/color/rgb/\(lipstick.lipstickColor.toHex!)/trend", nil, nil) { (response, _) -> (Void) in
            if response == nil {
                completion([Trend]())
            }
            completion(Trend.makeArrayModelFromJSON(response: response))
        }
    }
}
