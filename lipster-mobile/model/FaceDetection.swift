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
    
    
    var vision = Vision.vision()
    let options = VisionFaceDetectorOptions()
    var multiplier = 1.0
    var maintainSize = CGRect()
    let metadata = VisionImageMetadata()
    
    init() {
        options.classificationMode = .none
        options.contourMode = .all
        options.landmarkMode = .none
        options.performanceMode = .fast
    }
    
    public func getLipColorFromImage(for source: UIImageView, complete: @escaping ((UIColor)?) -> Void){
        var colorDetect: UIColor?
        maintainSize = AVMakeRect(aspectRatio: source.image!.size, insideRect: source.frame)
        multiplier = Double(maintainSize.size.width / (source.image?.size.width)!)
        
        let image = VisionImage(image: source.image!)
        self.getLipsLandmarksFireBase(for: image, mode: .accurate, frame: source, options: [.upperLipBottom]) { (contourDictionary) in
            
            guard (contourDictionary != nil), let upperLipBottom = contourDictionary!["UpperLipBottom"]!, !upperLipBottom.isEmpty else {
                
                complete(UIColor.black)
                return
            }
            colorDetect = source.getPixelColor(point: upperLipBottom[1])
            
            complete(colorDetect)
        }
    }
    
    public func drawLipLandmarkLayer(for sourceBuffer: CMSampleBuffer, frame: UIView, complete: @escaping ((Dictionary<String, [CGPoint]?>)?) -> Void) {
        
        let deviceOrientation = UIDevice.current.orientation
        switch deviceOrientation {
        case .portrait:
            metadata.orientation = .leftTop
        case .landscapeLeft:
            metadata.orientation = .bottomLeft
        case .portraitUpsideDown:
            metadata.orientation = .rightBottom
        case .landscapeRight:
            metadata.orientation = .topRight
        case .faceDown, .faceUp, .unknown:
            metadata.orientation = .leftTop
        }
        
        let image = VisionImage(buffer: sourceBuffer)
        image.metadata = metadata
        
        getLipsLandmarksFireBase(for: image, mode: .fast, frame: frame, options: [.upperLipTop, .upperLipBottom, .lowerLipTop, .lowerLipBottom]) { (contourDictionary) in
            complete(contourDictionary)
        }
        
    }

}

// MARK: Private Function
extension FaceDetection {
    
    private func getLipsLandmarksFireBase(for visionImage: VisionImage, mode: Accuracy, frame: UIView, options contourOptions: [FaceContourType], complete: @escaping (Dictionary<String, [CGPoint]?>?) -> Void) {
        
        switch mode {
        case .accurate:
            options.performanceMode = .accurate
            break
        case .fast:
            options.performanceMode = .fast
            break
        }

        let faceDetector = vision.faceDetector(options: options)

        var contourPoints = Dictionary<String, [CGPoint]?>()
        faceDetector.process(visionImage) { faces, err in
            guard err == nil, let faces = faces, !faces.isEmpty else {
                complete(nil)
                return
            }
            for face in faces {
                for contourOption in contourOptions {
                    contourPoints[contourOption.rawValue] = self.getContourPoint(face: face, type: contourOption, for: frame)
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
                        complete(landmarkPoints!)
                    }
                }
            }
            
        }
        let vnImage = VNImageRequestHandler(cgImage: (source.image?.cgImage)!, options: [:])
        try? vnImage.perform([faceDetectRequest])
    }
}
