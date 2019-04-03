import UIKit
import Vision

class FaceDetection {
    open func getLipsLandmarks(for source: UIImage, complete: @escaping (String) -> Void) {
        let faceDetectRequest = VNDetectFaceLandmarksRequest { (request, error) in
            if error == nil {
                if let results = request.results as? [VNFaceObservation] {
                    for faceObservation in results {
                        guard let landmarks = faceObservation.landmarks else {
                            continue
                        }
                        var innerLip = landmarks.innerLips
                        var outerLip = landmarks.outerLips
                        
                        
                    }
                }
            }
            complete("#ffffff")
        }
    }
}
