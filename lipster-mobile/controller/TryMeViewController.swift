//
//  TryMeViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 17/4/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit
import AVFoundation
import ReactiveCocoa
import ReactiveSwift
import Result

class TryMeViewController: UIViewController  {
 
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var previewLayer: PreviewMaskLayer!
    
    var session: AVCaptureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var input: AVCaptureDeviceInput?
    var output: AVCaptureVideoDataOutput?
    let faceDetection: FaceDetection = FaceDetection()
    let videoOutputQueue = DispatchQueue(label: "videoOutput", qos: .userInteractive, attributes: .concurrent)
    
    let lipstickARPipe = Signal<Dictionary<String, [CGPoint]?>?, NoError>.pipe()
    var lipstickARObserver: Signal<Dictionary<String, [CGPoint]?>?, NoError>.Observer?
    
    let colorCode:[UIColor] = [UIColor(rgb: 0xB74447),UIColor(rgb: 0xFA4855),UIColor(rgb: 0xFE486B),UIColor(rgb: 0xFF9A94) ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        previewLayer.session = session
        session.sessionPreset = .medium
        output = AVCaptureVideoDataOutput()
        output?.setSampleBufferDelegate(self, queue: videoOutputQueue)
        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {return}
        
        input = try? AVCaptureDeviceInput(device: frontCamera)
        
        if session.canAddInput(input!) {
            session.addInput(input!)
        }
        
        if session.canAddOutput(output!) {
            session.addOutput(output!)
        }
        configureReactiveAR()
        session.startRunning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session.stopRunning()
    }
}

extension TryMeViewController : UICollectionViewDataSource ,UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  colorCode.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! LipSelectedColorCollectionViewCell
        cell.colorDisplay.backgroundColor = colorCode[indexPath.item]
        cell.triangleView.isHidden = true
        cell.bringSubviewToFront(cell.triangleView)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("click")
        let cell = collectionView.cellForItem(at: indexPath) as! LipSelectedColorCollectionViewCell
        cell.triangleView.isHidden = false
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("declick")
        let cell = collectionView.cellForItem(at: indexPath) as! LipSelectedColorCollectionViewCell
        cell.triangleView.isHidden = true
    }
    
}

extension TryMeViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        videoOutputQueue.async {
            self.faceDetection.drawLipLandmarkLayer(for: sampleBuffer, frame: self.previewLayer.videoPreviewLayer, complete: { (contourDictionary) in
                self.lipstickARPipe.input.send(value: contourDictionary)
            })
        }

    }
    
    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
    }
}

// MARK: Reactive Configure
extension TryMeViewController {
    func configureReactiveAR() {
        lipstickARObserver = Signal<Dictionary<String, [CGPoint]?>?, NoError>.Observer(value: { (contourDictionary) in
            self.previewLayer.removeMask()
            self.previewLayer.drawLandmark(for: contourDictionary, lipstickColor: UIColor.red)
        })
        
        lipstickARPipe.output.observe(lipstickARObserver!)
    }
}
