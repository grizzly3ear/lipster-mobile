import Foundation
import UIKit
import SwiftyJSON
import SDWebImage

class TrendRepository {
    
    public static func fetchAllTrendData(completion: @escaping ([TrendGroup]) -> Void) {
        let request = HttpRequest()
        request.get("api/trend/collection", ["part": "trend"], nil) { (response, _) -> (Void) in
            if response == nil {
                completion([TrendGroup]())
            }
            completion(TrendGroup.makeArrayModelFromJSON(response: response))
        } 
    }
}
