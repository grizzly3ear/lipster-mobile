import Foundation
import UIKit
import SwiftyJSON
import SDWebImage

class StoreRepository {
    
    public static func fetchAllStore(completion: @escaping ([Store]) -> Void) {
        let request = HttpRequest()
        request.get("api/store", ["part": "address"], nil) { (response, httpStatusCode) -> (Void) in
            
            if response == nil {
                completion([Store]())
            }
            completion(Store.makeArrayModelFromJSON(response: response))
        }
    }
    
    public static func fetchStoreByLipstick(_ lipstick: Lipstick, completion: @escaping ([Store]) -> Void) {
        let request = HttpRequest()
        request.get("api/lipstick/color/\(lipstick.lipstickId)/store", ["part": "store"], nil) { (response, httpStatusCode) -> (Void) in
            
            if response == nil {
                completion([Store]())
            }
            completion(Store.makeArrayModelFromStoreAddressJSON(response: response))
        }
    }
}
