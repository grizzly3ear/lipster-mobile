////
////  TryMeViewController.swift
////  lipster-mobile
////
////  Created by Mainatvara on 17/4/2562 BE.
////  Copyright © 2562 Bank. All rights reserved.
////
//// WIP
//import UIKit
//import AVFoundation
//import ReactiveCocoa
//import ReactiveSwift
//import Result
//
//class TryMeViewController: UIViewController  {
// 
////    lazy var vision = Vision.vision()
//    
//    @IBOutlet weak var collectionView: UICollectionView!
//    @IBOutlet weak var previewLayer: PreviewMaskLayer!
//    
//    var session: AVCaptureSession = AVCaptureSession()
//    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
//    var input: AVCaptureDeviceInput?
//    var output: AVCaptureVideoDataOutput?
//    let videoOutputQueue = DispatchQueue(label: "videoOutput", qos: .userInteractive, attributes: .concurrent)
//    var lastFrame: CMSampleBuffer?
//    
//    let lipstickARPipe = Signal<Dictionary<String, [CGPoint]?>?, NoError>.pipe()
//    var lipstickARObserver: Signal<Dictionary<String, [CGPoint]?>?, NoError>.Observer?
//    
//    let colorCode:[UIColor] = [UIColor(rgb: 0xB74447),UIColor(rgb: 0xFA4855),UIColor(rgb: 0xFE486B),UIColor(rgb: 0xFF9A94) ]
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        previewLayer.session = session
//        session.sessionPreset = .medium
//        output = AVCaptureVideoDataOutput()
//        output?.setSampleBufferDelegate(self, queue: videoOutputQueue)
//        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {return}
//        
//        input = try? AVCaptureDeviceInput(device: frontCamera)
//        
//        if session.canAddInput(input!) {
//            session.addInput(input!)
//        }
//        
//        if session.canAddOutput(output!) {
//            session.addOutput(output!)
//        }
//        initReactiveAR()
//        session.startRunning()
//        
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        session.stopRunning()
//    }
//}
//
//extension TryMeViewController : UICollectionViewDataSource ,UICollectionViewDelegate{
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return  colorCode.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! LipSelectedColorCollectionViewCell
//        cell.colorDisplay.backgroundColor = colorCode[indexPath.item]
//        cell.triangleView.isHidden = true
//        cell.bringSubviewToFront(cell.triangleView)
//        
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        let cell = collectionView.cellForItem(at: indexPath) as! LipSelectedColorCollectionViewCell
//        cell.triangleView.isHidden = false
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath) as! LipSelectedColorCollectionViewCell
//        cell.triangleView.isHidden = true
//    }
//    
//}
//
//extension TryMeViewController {
//    func detectFaces(image: UIImage?) {
//        guard let image = image else { return }
//        
//        // Create a face detector with options.
//        // [START config_face]
//        let options = VisionFaceDetectorOptions()
//        options.landmarkMode = .all
//        options.classificationMode = .all
//        options.performanceMode = .accurate
//        options.contourMode = .all
//        // [END config_face]
//        
//        // [START init_face]
//        let faceDetector = vision.faceDetector(options: options)
//        // [END init_face]
//        
//        // Define the metadata for the image.
//        let imageMetadata = VisionImageMetadata()
//        imageMetadata.orientation = UIUtilities.visionImageOrientation(from: image.imageOrientation)
//        
//        // Initialize a VisionImage object with the given UIImage.
//        let visionImage = VisionImage(image: image)
//        visionImage.metadata = imageMetadata
//        
//        // [START detect_faces]
//        faceDetector.process(visionImage) { faces, error in
//            guard error == nil, let faces = faces, !faces.isEmpty else {
//                // [START_EXCLUDE]
//                let errorString = error?.localizedDescription ?? Constants.detectionNoResultsMessage
//                self.resultsText = "On-Device face detection failed with error: \(errorString)"
//                self.showResults()
//                // [END_EXCLUDE]
//                return
//            }
//            
//            // Faces detected
//            // [START_EXCLUDE]
//            faces.forEach { face in
//                let transform = self.transformMatrix()
//                let transformedRect = face.frame.applying(transform)
//                UIUtilities.addRectangle(
//                    transformedRect,
//                    to: self.annotationOverlayView,
//                    color: UIColor.green
//                )
//                self.addLandmarks(forFace: face, transform: transform)
//                self.addContours(forFace: face, transform: transform)
//            }
//            self.resultsText = faces.map { face in
//                let headEulerAngleY = face.hasHeadEulerAngleY ? face.headEulerAngleY.description : "NA"
//                let headEulerAngleZ = face.hasHeadEulerAngleZ ? face.headEulerAngleZ.description : "NA"
//                let leftEyeOpenProbability = face.hasLeftEyeOpenProbability ? face.leftEyeOpenProbability.description : "NA"
//                let rightEyeOpenProbability = face.hasRightEyeOpenProbability ? face.rightEyeOpenProbability.description : "NA"
//                let smilingProbability = face.hasSmilingProbability ? face.smilingProbability.description : "NA"
//                let output = """
//                Frame: \(face.frame)
//                Head Euler Angle Y: \(headEulerAngleY)
//                Head Euler Angle Z: \(headEulerAngleZ)
//                Left Eye Open Probability: \(leftEyeOpenProbability)
//                Right Eye Open Probability: \(rightEyeOpenProbability)
//                Smiling Probability: \(smilingProbability)
//                """
//                return "\(output)"
//                }.joined(separator: "\n")
//            self.showResults()
//            // [END_EXCLUDE]
//        }
//        // [END detect_faces]
//    }
//}
