import UIKit
import Vision

class FaceDetection {
    private static func getLipsLandmarks(for source: UIImageView, complete: @escaping ([CGPoint]) -> Void) {
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
                        
                        let landmarkPoints = innerLip?.normalizedPoints.map({ (point) -> CGPoint in
                            
                            let landmarkPoint: CGPoint = CGPoint(x: boundingRect.origin.x * source.image!.size.width + point.x * rectWidth,
                                                   y: boundingRect.origin.y * source.image!.size.height + point.y * rectHeight)
//                            print("\(landmarkPoint) color is \(source.image!.getPixelColor(pos: landmarkPoint))")
                            
                            return landmarkPoint
                        })
                        print(landmarkPoints)
                        complete(landmarkPoints!)
                    }
                }
            }
            
        }
        let vnImage = VNImageRequestHandler(cgImage: (source.image?.cgImage)!, options: [:])
        try? vnImage.perform([faceDetectRequest])
    }
    
    public static func getLipColorFromImage(for source: UIImageView) -> UIColor {
        var colorDetect: UIColor?
        
        FaceDetection.getLipsLandmarks(for: source) { (points) in
            print(points)
            colorDetect = source.image!.getPixelColor(pos: points[4])
        }
        
        return colorDetect ?? UIColor.black
    }
    
    func drawLipLandmarkLayer(for source: UIImageView) {
        FaceDetection.getLipsLandmarks(for: source) { (points) in
            // draw some line
        }
    }
}

extension FaceDetection {

}
