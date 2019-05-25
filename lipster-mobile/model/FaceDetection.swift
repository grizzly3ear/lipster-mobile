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
    let options = VisionFaceDetectorOptions()
    var multiplier = 1.0
    var maintainSize = CGRect()
    let metadata = VisionImageMetadata()
    var contourDictionary = Dictionary<String, [CGPoint]?>()
    
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
        self.getLipsLandmarksFireBase(for: image, mode: .accurate, frame: source, options: [.upperLipBottom], width: source.frame.width, height: source.frame.height) { (contourDictionary) in
            
            guard (contourDictionary != nil), let upperLipBottom = contourDictionary!["UpperLipBottom"]!, !upperLipBottom.isEmpty else {
                
                complete(UIColor.black)
                return
            }
            colorDetect = source.getPixelColor(point: upperLipBottom[1])
            
            complete(colorDetect)
        }
    }
    
    public func drawLipLandmarkLayer(for sourceBuffer: CMSampleBuffer, frame: UIView, complete: @escaping ((Dictionary<String, [CGPoint]?>)?) -> Void) {

        let image = VisionImage(buffer: sourceBuffer)
        
        let orientation = UIUtilityHelper.imageOrientation(fromDevicePosition: .front)
        let visionOrientation = UIUtilityHelper.visionImageOrientation(from: orientation)
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sourceBuffer) else {
            print("Failed to get image buffer from sample buffer.")
            return
        }
        
        metadata.orientation = visionOrientation
        image.metadata = metadata
        
        let imageWidth = CGFloat(CVPixelBufferGetWidth(imageBuffer))
        let imageHeight = CGFloat(CVPixelBufferGetHeight(imageBuffer))
        
        let options: [FaceContourType] = [
            .lowerLipTop,
            .lowerLipBottom,
            .upperLipTop,
            .upperLipBottom
        ]
        
        getLipsLandmarksFireBase(for: image, mode: .fast, frame: frame, options: options, width: imageWidth, height: imageHeight) { (contourDictionary) in
            complete(contourDictionary)
        }
        
    }

}

// MARK: Private Function
extension FaceDetection {
    
    private func getLipsLandmarksFireBase(for visionImage: VisionImage, mode: Accuracy, frame: UIView, options contourOptions: [FaceContourType], width: CGFloat, height: CGFloat, complete: @escaping (Dictionary<String, [CGPoint]?>?) -> Void) {
        
        switch mode {
        case .accurate:
            options.performanceMode = .accurate
            break
        case .fast:
            options.performanceMode = .fast
            break
        }

        let faceDetector = vision.faceDetector(options: options)
        
        faceDetector.process(visionImage) { (faces, err) in
            guard err == nil, let faces = faces, !faces.isEmpty else {
                complete(nil)
                return
            }
            
            for face in faces {
                if mode == .accurate {
                    self.contourDictionary["UpperLipBottom"] = self.getContourPoint(face: face, type: .upperLipBottom, for: frame)
                } else {
                    self.addContours(for: face, width: width, height: height, for: frame as! PreviewMaskLayer)
                }
                
            }
            complete(self.contourDictionary)

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
    
    private func addContours(for face: VisionFace, width: CGFloat, height: CGFloat, for previewMaskLayer: PreviewMaskLayer) {
        if let topUpperLipContour = face.contour(ofType: .upperLipTop) {
            var points = [CGPoint]()
            for point in topUpperLipContour.points {
                let cgPoint = normalizedPoint(fromVisionPoint: point, width: width, height: height, previewMaskLayer: previewMaskLayer)
                points.append(cgPoint)
            }
            contourDictionary["UpperLipTop"] = points
        }
        if let bottomUpperLipContour = face.contour(ofType: .upperLipBottom) {
            var points = [CGPoint]()
            for point in bottomUpperLipContour.points {
                let cgPoint = normalizedPoint(fromVisionPoint: point, width: width, height: height, previewMaskLayer: previewMaskLayer)
                points.append(cgPoint)
            }
            contourDictionary["UpperLipBottom"] = points
        }
        if let topLowerLipContour = face.contour(ofType: .lowerLipTop) {
            var points = [CGPoint]()
            for point in topLowerLipContour.points {
                let cgPoint = normalizedPoint(fromVisionPoint: point, width: width, height: height, previewMaskLayer: previewMaskLayer)
                points.append(cgPoint)
            }
            contourDictionary["LowerLipTop"] = points
        }
        if let bottomLowerLipContour = face.contour(ofType: .lowerLipBottom) {
            var points = [CGPoint]()
            for point in bottomLowerLipContour.points {
                let cgPoint = normalizedPoint(fromVisionPoint: point, width: width, height: height, previewMaskLayer: previewMaskLayer)
                points.append(cgPoint)
            }
            contourDictionary["LowerLipBottom"] = points
        }
    }
    
    private func normalizedPoint(fromVisionPoint point: VisionPoint, width: CGFloat, height: CGFloat, previewMaskLayer: PreviewMaskLayer) -> CGPoint {
        let cgPoint = CGPoint(x: CGFloat(point.x.floatValue), y: CGFloat(point.y.floatValue))
        var normalizedPoint = CGPoint(x: cgPoint.x / width, y: cgPoint.y / height)
        normalizedPoint = previewMaskLayer.videoPreviewLayer.layerPointConverted(fromCaptureDevicePoint: normalizedPoint)
        return normalizedPoint
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
