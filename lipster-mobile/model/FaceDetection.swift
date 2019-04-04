import UIKit
import Vision

class FaceDetection {
    public static func getLipsLandmarks(for source: UIImageView, complete: @escaping (UIColor) -> Void) {
        let faceDetectRequest = VNDetectFaceLandmarksRequest { (request, error) in
            if error == nil {
                if let results = request.results as? [VNFaceObservation] {
                    for faceObservation in results {
                        guard let landmarks = faceObservation.landmarks else {
                            continue
                        }
                        let boundingRect = faceObservation.boundingBox
                        
                        let rectWidth = source.image!.size.width * boundingRect.size.width
                        let rectHeight = source.image!.size.height * boundingRect.size.height
                        
                        let innerLip = landmarks.innerLips
                        var outerLip = landmarks.outerLips
                        
                        let colorMapPoints = outerLip?.normalizedPoints.map({ (point) -> UIColor in
                            
                            let landmarkPoint: CGPoint = CGPoint(x: boundingRect.origin.x * source.image!.size.width + point.x * rectWidth,
                                                   y: boundingRect.origin.y * source.image!.size.height + point.y * rectHeight)
                            print("\(landmarkPoint) color is \(source.image!.getPixelColor(pos: landmarkPoint))")
                            
                            return source.image!.getPixelColor(pos: landmarkPoint)
                        })
                        print("\(colorMapPoints?.count)")
                        complete((colorMapPoints?[4])!)
                    }
                }
            }
            
        }
        let vnImage = VNImageRequestHandler(cgImage: (source.image?.cgImage)!, options: [:])
        try? vnImage.perform([faceDetectRequest])
    }
}

extension FaceDetection {

}
