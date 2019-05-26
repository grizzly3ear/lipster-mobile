import UIKit
import Vision
import AVFoundation

import FirebaseMLVision
import FirebaseMLCommon

class FaceDetection {
    
    private lazy var vision = Vision.vision()
    private let options = VisionFaceDetectorOptions()
    private var multiplier = 1.0
    private var maintainSize = CGRect()
    private let metadata = VisionImageMetadata()
    
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
        
        self.getAccurateLipsLandmarks(for: source) { (contourDictionary) in
            print(contourDictionary)
            guard let upperLipBottom = contourDictionary["UpperLipBottom"]!, !upperLipBottom.isEmpty else {
                
                complete(UIColor.black)
                return
            }
            colorDetect = source.image?.getPixelColor(pos: upperLipBottom[3])
            
            complete(colorDetect)
        }
    }
    
    public func drawLipLandmarkLayer(for sourceBuffer: CMSampleBuffer, previewLayer: AVCaptureVideoPreviewLayer, complete: @escaping ((Dictionary<String, [CGPoint]?>)?) -> Void) {

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
        
        let contourOptions: [FaceContourType] = [
            .lowerLipTop,
            .lowerLipBottom,
            .upperLipTop,
            .upperLipBottom
        ]
        
        getFastLipsLandmarks(for: image, previewLayer: previewLayer, contourOptions: contourOptions, width: imageWidth, height: imageHeight) { (contourDictionary) in
            complete(contourDictionary)
        }
        
    }

}

// MARK: Private Function
extension FaceDetection {
    
    private func getFastLipsLandmarks(for visionImage: VisionImage, previewLayer: AVCaptureVideoPreviewLayer, contourOptions: [FaceContourType], width: CGFloat, height: CGFloat, complete: @escaping (Dictionary<String, [CGPoint]?>) -> Void) {
        
        let faceDetector = vision.faceDetector(options: options)
        var contourDictionary = Dictionary<String, [CGPoint]?>()
        faceDetector.process(visionImage) { (faces, err) in
            guard err == nil, let faces = faces, !faces.isEmpty else {
                complete(contourDictionary)
                return
            }
            
            for face in faces {
                contourDictionary = self.getContourPoint(for: face, width: width, height: height, for: previewLayer, contourOptions: [.upperLipTop, .upperLipBottom, .lowerLipTop, .lowerLipBottom])
                
            }
            complete(contourDictionary)

        }
        complete(contourDictionary)
    }
    
    private func getAccurateLipsLandmarks(for source: UIImageView, complete: @escaping (Dictionary<String, [CGPoint]?>) -> Void) {
        let faceDetectRequest = VNDetectFaceLandmarksRequest { (request, error) in
            if error == nil {
                var contourDictionary = Dictionary<String, [CGPoint]?>()
                if let results = request.results as? [VNFaceObservation] {
                    for faceObservation in results {
                        guard let landmarks = faceObservation.landmarks else {
                            continue
                        }
                        let boundingRect = faceObservation.boundingBox
                        
                        let rectWidth = source.image!.size.width * boundingRect.size.width
                        let rectHeight = source.image!.size.height * boundingRect.size.height
                        
                        let innerLip = landmarks.innerLips
                        //                        var outerLip = landmarks.outerLips
                        
                        let landmarkPoints = innerLip?.normalizedPoints.map({ (point) -> CGPoint in
                            
                            let imageRealSize = source.image!.size
                            print(imageRealSize)
                            
                            let landmarkPoint: CGPoint = CGPoint(x: boundingRect.origin.x * source.image!.size.width + point.x * rectWidth,
                                                                 y: imageRealSize.height - (boundingRect.origin.y * source.image!.size.height + point.y * rectHeight))
                            
                            return landmarkPoint
                        })
                        contourDictionary["UpperLipBottom"] = landmarkPoints
                        complete(contourDictionary)
                    }
                }
                complete(contourDictionary)
            }
        }
        
        let vnImage = VNImageRequestHandler(cgImage: (source.image?.cgImage)!, options: [:])
        try? vnImage.perform([faceDetectRequest])
    }
    
    private func getContourPoint(for face: VisionFace, width: CGFloat, height: CGFloat, for previewLayer: AVCaptureVideoPreviewLayer, contourOptions: [FaceContourType]) -> Dictionary<String, [CGPoint]?> {
        var contourDictionary = Dictionary<String, [CGPoint]?>()
        for contourOption in contourOptions {
            if let contour = face.contour(ofType: contourOption) {
                var points = [CGPoint]()
                for point in contour.points {
                    let cgPoint = normalizedPoint(fromVisionPoint: point, width: width, height: height, previewLayer: previewLayer)
                    points.append(cgPoint)
                }
                contourDictionary[contourOption.rawValue] = points
            }
        }
        
        return contourDictionary
    }
    
    private func normalizedPoint(fromVisionPoint point: VisionPoint, width: CGFloat, height: CGFloat, previewLayer: AVCaptureVideoPreviewLayer) -> CGPoint {
        let cgPoint = CGPoint(x: CGFloat(point.x.floatValue), y: CGFloat(point.y.floatValue))
        var normalizedPoint = CGPoint(x: cgPoint.x / width, y: cgPoint.y / height)
        
        normalizedPoint = previewLayer.layerPointConverted(fromCaptureDevicePoint: normalizedPoint)
        return normalizedPoint
    }
}

// MARK: Deprecate
extension FaceDetection {
    
    private func getContourPoint(face: VisionFace, options contourTypes: [FaceContourType], for source: UIView) -> Dictionary<String, [CGPoint]?> {
        var contourDictionary = Dictionary<String, [CGPoint]?>()
        var points = [CGPoint]()
        for contourType in contourTypes {
            if let contour = face.contour(ofType: contourType) {
                points = contour.points.map { (visionPoint) -> CGPoint in
                    let x = (visionPoint.x.doubleValue * multiplier) + (Double(maintainSize.minX) - Double(source.frame.minX))
                    let y = (visionPoint.y.doubleValue * multiplier) + (Double(maintainSize.minY) - Double(source.frame.minY))
                    
                    return CGPoint(x: x, y: y)
                }
                contourDictionary[contourType.rawValue] = points
            }
        }
        
        return contourDictionary
    }
    
}
