import UIKit
import Vision
import AVFoundation

import FirebaseMLVision
import FirebaseMLCommon

enum Accuracy {
    case accurate
    case fast
}

class FaceDetection {
    
    lazy var vision = Vision.vision()
    var multiplier = 1.0
    var maintainSize = CGRect()
    
    init() {
    }
    
    public func getLipColorFromImage(for source: UIImageView, complete: @escaping ((UIColor)?) -> Void){
        var colorDetect: UIColor?
        
//        print("multiplier: \(multiplier)")
//
//        print("maintain minX: \(maintainSize.minX)")
//        print("maintain maxX: \(maintainSize.maxX)")
//        print("maintain minY: \(maintainSize.minY)")
//        print("maintain maxY: \(maintainSize.maxY)")
//        print("maintain width: \(maintainSize.width)")
//        print("maintain height: \(maintainSize.height)")
//
//        print("source.frame minX: \(source.frame.minX)")
//        print("source.frame maxX: \(source.frame.maxX)")
//        print("source.frame minY: \(source.frame.minY)")
//        print("source.frame maxY: \(source.frame.maxY)")
//        print("source.frame width: \(source.frame.width)")
//        print("source.frame height: \(source.frame.height)")
//
//        print("image width: \(source.image!.size.width)")
//        print("image height: \(source.image!.size.height)")
        
        self.getLipsLandmarksFireBase(for: source, mode: .accurate, options: [.upperLipBottom]) { (contourDictionary) in
            print("check contour resposne: \(contourDictionary)")
            guard (contourDictionary != nil), let upperLipBottom = contourDictionary!["UpperLipBottom"]!, !upperLipBottom.isEmpty else {
                complete(UIColor.black)
                return
            }
            print("finding color...")
            colorDetect = source.getPixelColor(point: upperLipBottom[1])
            print("find complete: \(colorDetect)")
            print("from point: \(upperLipBottom[1])")
            complete(colorDetect)
        }
    }
    
    public func drawLipLandmarkLayer(for source: UIImageView) {
        maintainSize = AVMakeRect(aspectRatio: source.image!.size, insideRect: source.frame)
        multiplier = Double(maintainSize.size.width / (source.image?.size.width)!)
        
        self.getLipsLandmarksFireBase(for: source, mode: .fast, options: [.upperLipBottom, .upperLipTop, .lowerLipBottom, .lowerLipTop]) { (contourDictionary) in
            
        }
    }

}

// MARK: Private Function
extension FaceDetection {
    
    private func getLipsLandmarksFireBase(for source: UIImageView, mode: Accuracy, options contourOptions: [FaceContourType], complete: @escaping (Dictionary<String, [CGPoint]?>?) -> Void) {
        let options = VisionFaceDetectorOptions()
        
        switch mode {
        case .accurate:
            options.performanceMode = .accurate
            break
        case .fast:
            options.performanceMode = .fast
            break
        }
        
        options.contourMode = .all
        
        let faceDetector = vision.faceDetector(options: options)
        
        let visionImage = VisionImage(image: source.image!)
        
        var contourPoints = Dictionary<String, [CGPoint]?>()
        faceDetector.process(visionImage) { faces, err in
            guard err == nil, let faces = faces, !faces.isEmpty else {
                complete(nil)
                return
            }
            for face in faces {
                for contourOption in contourOptions {
                    contourPoints[contourOption.rawValue] = self.getContourPoint(face: face, type: contourOption, for: source)
                }
            }
            complete(contourPoints)
        }
    }
    
    private func getContourPoint(face: VisionFace, type: FaceContourType, for source: UIView) -> [CGPoint] {
        var points = [CGPoint]()
        if let contour = face.contour(ofType: type) {
            points = contour.points.map { (visionPoint) -> CGPoint in
                let x = (visionPoint.x.doubleValue * multiplier) + (Double(maintainSize.minX) - Double(source.frame.minX))
                let y = (visionPoint.y.doubleValue * multiplier) + (Double(maintainSize.minY) - Double(source.frame.minY))
                
                return CGPoint(x: x, y: y)
            }
            return points
        }
        return points
    }
}

// MARK: Deprecate
extension FaceDetection {
    
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
}
