import UIKit
import AVFoundation

class PreviewMaskLayer: UIView {
    
    private var maskLayer = [CAShapeLayer]()
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
    
    var session: AVCaptureSession? {
        get {
            return videoPreviewLayer.session
        }
        set {
            videoPreviewLayer.session = newValue
        }
    }
    
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    // TODO: Change parameter in craeteLayer for face bound
    public func drawLandmark(for contourPoints: Dictionary<String, [CGPoint]?>?, lipstickColor: UIColor) {
        
        let faceLayer = createLayer(in: frame)
        
        guard contourPoints != nil else { return }

        drawLandMarks(on: faceLayer, landmarkPoints: contourPoints!["LowerLipTop"]!, isClosed: false, color: lipstickColor)
        drawLandMarks(on: faceLayer, landmarkPoints: contourPoints!["LowerLipBottom"]!, isClosed: false, color: lipstickColor)
        drawLandMarks(on: faceLayer, landmarkPoints: contourPoints!["UpperLipTop"]!, isClosed: false, color: lipstickColor)
        drawLandMarks(on: faceLayer, landmarkPoints: contourPoints!["UpperLipBottom"]!, isClosed: false, color: lipstickColor)
        
    }
    
    public func removeMask() {
        for mask in maskLayer {
            mask.removeFromSuperlayer()
        }
        maskLayer.removeAll()
    }
    
}

// MARK: Draw Function
extension PreviewMaskLayer {
    
    private func createLayer(in rect: CGRect) -> CAShapeLayer {
        let mask = CAShapeLayer()
        mask.frame = rect
        
        maskLayer.append(mask)
        layer.insertSublayer(mask, at: 1)
        
        return mask
    }
    
    // TODO: Add argument to this method to recieve face contour points
    private func drawLandMarks(on targetLayer: CALayer, landmarkPoints: [CGPoint]?, isClosed: Bool = true, color: UIColor) {
        let rect: CGRect = targetLayer.frame
        guard landmarkPoints != nil else { return }
        
        var points: [CGPoint] = []
        
        for i in 0..<landmarkPoints!.count {
            let point = landmarkPoints![i]
            points.append(point)
        }
        
        let landmarkLayer = drawPointsOnLayer(landmarkPoints: points, isClosed: isClosed, color: color)
        
        targetLayer.insertSublayer(landmarkLayer, at: 1)
    }
    
    // TODO: Add color of lipstick in lineLayer.fillColor
    private func drawPointsOnLayer(landmarkPoints: [CGPoint], isClosed: Bool = true, color: UIColor) -> CALayer {
        let linePath = UIBezierPath()
        linePath.move(to: landmarkPoints.first!)
        
        for point in landmarkPoints.dropFirst() {
            linePath.addLine(to: point)
        }
        
        if isClosed {
            linePath.addLine(to: landmarkPoints.first!)
        }
        
        let lineLayer = CAShapeLayer()
        lineLayer.path = linePath.cgPath
//        lineLayer.fillColor = color.cgColor
        lineLayer.opacity = 1.0
        lineLayer.lineWidth = 1.0
        
        return lineLayer
    }
    
    
}

