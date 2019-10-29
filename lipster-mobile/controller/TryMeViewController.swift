//
//  TryMeViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 17/4/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit
import AVFoundation
import SPStorkController

import Firebase

class TryMeViewController: UIViewController  {
    
    private var currentDetector: Detector = .onDeviceFace
    private var isUsingFrontCamera = true
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private lazy var captureSession = AVCaptureSession()
    private lazy var sessionQueue = DispatchQueue(label: Constant.sessionQueueLabel)
    private lazy var vision = Vision.vision()
    private var lastFrame: CMSampleBuffer?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet private weak var cameraView: UIView!
    
    private lazy var previewOverlayView: UIImageView = {
        precondition(isViewLoaded)
        let previewOverlayView = UIImageView(frame: .zero)
        previewOverlayView.contentMode = UIView.ContentMode.scaleAspectFill
        previewOverlayView.translatesAutoresizingMaskIntoConstraints = false
        return previewOverlayView
    }()
    
    private lazy var annotationOverlayView: UIView = {
        precondition(isViewLoaded)
        let annotationOverlayView = UIView(frame: .zero)
        annotationOverlayView.translatesAutoresizingMaskIntoConstraints = false
        return annotationOverlayView
    }()
    
    var lipstick: Lipstick!
    var lipsticks: [Lipstick]!
    let lipstickColorAlpha: CGFloat = 0.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        setUpPreviewOverlayView()
        setUpAnnotationOverlayView()
        setUpCaptureSessionOutput()
        setUpCaptureSessionInput()
        collectionView.delegate = self
        collectionView.dataSource = self
//        collapseDetailView.layer.cornerRadius = 20
        self.hero.isEnabled = true
//        collapseDetailView.hero.id = "pullableView"
        
        hideTabBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        startSession()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        showTabBar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        stopSession()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        previewLayer.frame = cameraView.frame
        cameraView.bringSubviewToFront(collectionView)
    }
    
//    @IBAction func onPressDetail(_ sender: Any) {
//        let modal = storyboard?.instantiateViewController(withIdentifier: "LipstickDetailModalViewController") as! LipstickDetailModalViewController
//        let transitionDelegate = SPStorkTransitioningDelegate()
//        transitionDelegate.storkDelegate = self
//        modal.transitioningDelegate = transitionDelegate
//        modal.modalPresentationStyle = .custom
//        transitionDelegate.translateForDismiss = 100
//        modal.lipstick = lipstick
//
//        self.present(modal, animated: true, completion: nil)
//    }
    
}

extension TryMeViewController: SPStorkControllerDelegate {
    func didDismissStorkByTap() {
    }
    
    func didDismissStorkBySwipe() {
    }
}

extension TryMeViewController: UICollectionViewDataSource ,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  lipsticks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! LipSelectedColorCollectionViewCell
        cell.colorDisplay.backgroundColor = lipsticks[indexPath.item].lipstickColor
        
        if lipsticks[indexPath.item].lipstickId == lipstick?.lipstickId {
            cell.triangleView.isHidden = false
        } else {
            cell.triangleView.isHidden = true
        }
        cell.bringSubviewToFront(cell.triangleView)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        lipstick = lipsticks[indexPath.item]
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! LipSelectedColorCollectionViewCell
        cell.triangleView.isHidden = true
    }
    
}

extension TryMeViewController {
    private func setUpCaptureSessionOutput() {
        sessionQueue.async {
            self.captureSession.beginConfiguration()
            // When performing latency tests to determine ideal capture settings,
            // run the app in 'release' mode to get accurate performance metrics
            self.captureSession.sessionPreset = AVCaptureSession.Preset.medium
            
            let output = AVCaptureVideoDataOutput()
            output.videoSettings =
                [(kCVPixelBufferPixelFormatTypeKey as String): kCVPixelFormatType_32BGRA]
            let outputQueue = DispatchQueue(label: Constant.videoDataOutputQueueLabel)
            output.setSampleBufferDelegate(self, queue: outputQueue)
            guard self.captureSession.canAddOutput(output) else {
                print("Failed to add capture session output.")
                return
            }
            self.captureSession.addOutput(output)
            self.captureSession.commitConfiguration()
        }
    }
    
    private func setUpCaptureSessionInput() {
        sessionQueue.async {
            let cameraPosition: AVCaptureDevice.Position = self.isUsingFrontCamera ? .front : .back
            guard let device = self.captureDevice(forPosition: cameraPosition) else {
                print("Failed to get capture device for camera position: \(cameraPosition)")
                return
            }
            do {
                self.captureSession.beginConfiguration()
                let currentInputs = self.captureSession.inputs
                for input in currentInputs {
                    self.captureSession.removeInput(input)
                }
                
                let input = try AVCaptureDeviceInput(device: device)
                guard self.captureSession.canAddInput(input) else {
                    print("Failed to add capture session input.")
                    return
                }
                self.captureSession.addInput(input)
                self.captureSession.commitConfiguration()
            } catch {
                print("Failed to create capture device input: \(error.localizedDescription)")
            }
        }
    }
    
    private func startSession() {
        sessionQueue.async {
            self.captureSession.startRunning()
        }
    }
    
    private func stopSession() {
        sessionQueue.async {
            self.captureSession.stopRunning()
        }
    }
    
    private func setUpPreviewOverlayView() {
        cameraView.addSubview(previewOverlayView)
        NSLayoutConstraint.activate([
            previewOverlayView.centerXAnchor.constraint(equalTo: cameraView.centerXAnchor),
            previewOverlayView.centerYAnchor.constraint(equalTo: cameraView.centerYAnchor),
            previewOverlayView.leadingAnchor.constraint(equalTo: cameraView.leadingAnchor),
            previewOverlayView.trailingAnchor.constraint(equalTo: cameraView.trailingAnchor),
            
            ])
    }
    
    private func setUpAnnotationOverlayView() {
        cameraView.addSubview(annotationOverlayView)
        NSLayoutConstraint.activate([
            annotationOverlayView.topAnchor.constraint(equalTo: cameraView.topAnchor),
            annotationOverlayView.leadingAnchor.constraint(equalTo: cameraView.leadingAnchor),
            annotationOverlayView.trailingAnchor.constraint(equalTo: cameraView.trailingAnchor),
            annotationOverlayView.bottomAnchor.constraint(equalTo: cameraView.bottomAnchor),
            ])
    }
    
    private func updatePreviewOverlayView() {
        guard let lastFrame = lastFrame,
            let imageBuffer = CMSampleBufferGetImageBuffer(lastFrame)
            else {
                return
        }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
            return
        }
        let rotatedImage =
            UIImage(cgImage: cgImage, scale: Constant.originalScale, orientation: .right)
        if isUsingFrontCamera {
            guard let rotatedCGImage = rotatedImage.cgImage else {
                return
            }
            let mirroredImage = UIImage(
                cgImage: rotatedCGImage, scale: Constant.originalScale, orientation: .leftMirrored)
            previewOverlayView.image = mirroredImage
        } else {
            previewOverlayView.image = rotatedImage
        }
    }
    
    private func removeDetectionAnnotations() {
        for annotationView in annotationOverlayView.subviews {
            annotationView.removeFromSuperview()
        }
    }
    
    private func captureDevice(forPosition position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        if #available(iOS 10.0, *) {
            let discoverySession = AVCaptureDevice.DiscoverySession(
                deviceTypes: [.builtInWideAngleCamera],
                mediaType: .video,
                position: .unspecified
            )
            return discoverySession.devices.first { $0.position == position }
        }
        return nil
    }

}

extension TryMeViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
        ) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            print("Failed to get image buffer from sample buffer.")
            return
        }
        lastFrame = sampleBuffer
        let visionImage = VisionImage(buffer: sampleBuffer)
        let metadata = VisionImageMetadata()
        let orientation = UIUtilityHelper.imageOrientation(
            fromDevicePosition: isUsingFrontCamera ? .front : .back
        )
        
        let visionOrientation = UIUtilityHelper.visionImageOrientation(from: orientation)
        metadata.orientation = visionOrientation
        visionImage.metadata = metadata
        let imageWidth = CGFloat(CVPixelBufferGetWidth(imageBuffer))
        let imageHeight = CGFloat(CVPixelBufferGetHeight(imageBuffer))
        
        detectFacesOnDevice(in: visionImage, width: imageWidth, height: imageHeight)
    }
}

extension TryMeViewController {
    private func detectFacesOnDevice(in image: VisionImage, width: CGFloat, height: CGFloat) {
        let options = VisionFaceDetectorOptions()
        
        // When performing latency tests to determine ideal detection settings,
        // run the app in 'release' mode to get accurate performance metrics
        options.landmarkMode = .none
        options.contourMode = .all
        options.classificationMode = .none
        
        options.performanceMode = .fast
        let faceDetector = vision.faceDetector(options: options)
        
        var detectedFaces: [VisionFace]? = nil
        do {
            detectedFaces = try faceDetector.results(in: image)
        } catch let error {
            print("Failed to detect faces with error: \(error.localizedDescription).")
        }
        guard let faces = detectedFaces, !faces.isEmpty else {
            print("On-Device face detector returned no results.")
            DispatchQueue.main.sync {
                self.updatePreviewOverlayView()
                self.removeDetectionAnnotations()
            }
            return
        }
        
        DispatchQueue.main.sync {
            self.updatePreviewOverlayView()
            self.removeDetectionAnnotations()
            for face in faces {
                let normalizedRect = CGRect(
                    x: face.frame.origin.x / width,
                    y: face.frame.origin.y / height,
                    width: face.frame.size.width / width,
                    height: face.frame.size.height / height
                )
                _ =
                    self.previewLayer.layerRectConverted(fromMetadataOutputRect: normalizedRect).standardized
                self.addContours(for: face, width: width, height: height)
            }
        }
    }
    
    private func addContours(for face: VisionFace, width: CGFloat, height: CGFloat) {
        
        let view = annotationOverlayView
        let upperLipPath = UIBezierPath()
        let lowerLipPath = UIBezierPath()
        let rect = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        
        if let topUpperLipContour = face.contour(ofType: .upperLipTop) {
            for (index, point) in topUpperLipContour.points.enumerated() {
                let cgPoint = normalizedPoint(fromVisionPoint: point, width: width, height: height)
                if index == 0 {
                    upperLipPath.move(to: cgPoint)
                } else {
                    upperLipPath.addLine(to: cgPoint)
                }
            }
        }
        
        if let bottomUpperLipContour = face.contour(ofType: .upperLipBottom) {
            for (index, point) in bottomUpperLipContour.points.reversed().enumerated() {
                let cgPoint = normalizedPoint(fromVisionPoint: point, width: width, height: height)
                if index != 0 && index != bottomUpperLipContour.points.count - 1 {
                    upperLipPath.addLine(to: cgPoint)
                }
            }
        }
        
        upperLipPath.close()
        
        let upperShapeLayer = CAShapeLayer()
        upperShapeLayer.path = upperLipPath.cgPath
        upperShapeLayer.fillColor = lipstick.lipstickColor.cgColor
        let upperShapeView = UIView(frame: rect)
        upperShapeView.alpha = lipstickColorAlpha
        upperShapeView.layer.addSublayer(upperShapeLayer)
        view.addSubview(upperShapeView)
        
        if let bottomLowerLipContour = face.contour(ofType: .lowerLipBottom) {
            for (index, point) in bottomLowerLipContour.points.enumerated() {
                let cgPoint = normalizedPoint(fromVisionPoint: point, width: width, height: height)
                if index == 0 {
                    lowerLipPath.move(to: cgPoint)
                } else {
                    lowerLipPath.addLine(to: cgPoint)
                }
            }
        }
        
        if let topLowerLipContour = face.contour(ofType: .lowerLipTop) {
            for (index, point) in topLowerLipContour.points.reversed().enumerated() {
                let cgPoint = normalizedPoint(fromVisionPoint: point, width: width, height: height)
                if index != 0 && index != topLowerLipContour.points.count - 1 {
                    lowerLipPath.addLine(to: cgPoint)
                }
            }
        }

        lowerLipPath.close()
        
        let lowerShapeLayer = CAShapeLayer()
        lowerShapeLayer.path = lowerLipPath.cgPath
        lowerShapeLayer.fillColor = lipstick.lipstickColor.cgColor
        let lowerShapeView = UIView(frame: rect)
        lowerShapeView.alpha = lipstickColorAlpha
        lowerShapeView.layer.addSublayer(lowerShapeLayer)
        view.addSubview(lowerShapeView)
    }
}

extension TryMeViewController {
    private func normalizedPoint(
        fromVisionPoint point: VisionPoint,
        width: CGFloat,
        height: CGFloat
        ) -> CGPoint {
        let cgPoint = CGPoint(x: CGFloat(point.x.floatValue), y: CGFloat(point.y.floatValue))
        var normalizedPoint = CGPoint(x: cgPoint.x / width, y: cgPoint.y / height)
        normalizedPoint = previewLayer.layerPointConverted(fromCaptureDevicePoint: normalizedPoint)
        return normalizedPoint
    }
    
    private func normalizedPoint(
        fromVisionPoint points: [VisionPoint],
        width: CGFloat,
        height: CGFloat
        ) -> [CGPoint] {
        var normalizedPoints: [CGPoint] = [CGPoint]()
        for point in points {
            let cgPoint = CGPoint(x: CGFloat(point.x.floatValue), y: CGFloat(point.y.floatValue))
            var normalizedPoint = CGPoint(x: cgPoint.x / width, y: cgPoint.y / height)
            normalizedPoint = previewLayer.layerPointConverted(fromCaptureDevicePoint: normalizedPoint)
            normalizedPoints.append(normalizedPoint)
        }
        return normalizedPoints
    }
}

public enum Detector: String {
    case onDeviceFace = "On-Device Face Detection"
}

private enum Constant {
    static let videoDataOutputQueueLabel = "com.google.firebaseml.visiondetector.VideoDataOutputQueue"
    static let sessionQueueLabel = "com.google.firebaseml.visiondetector.SessionQueue"
    static let originalScale: CGFloat = 1.0
}
