//
//  TryMeViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 17/4/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit
import AVFoundation

class TryMeViewController: UIViewController  {
 
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var previewLayer: UIView!
    
    var session: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var input: AVCaptureDeviceInput?
    var output: AVCaptureVideoDataOutput?
    
    let colorCode:[UIColor] = [UIColor(rgb: 0xB74447),UIColor(rgb: 0xFA4855),UIColor(rgb: 0xFE486B),UIColor(rgb: 0xFF9A94) ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        session = AVCaptureSession()
        session!.sessionPreset = .medium
        output = AVCaptureVideoDataOutput()
        output?.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoOutput"))
        guard let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {return}
        
        input = try? AVCaptureDeviceInput(device: frontCamera)
        
        if (session?.canAddInput(input!))! {
            session?.addInput(input!)
        }
        
        if (session?.canAddOutput(output!))! {
            session?.addOutput(output!)
        }
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session!)
        videoPreviewLayer?.frame = previewLayer.frame
        previewLayer.layer.addSublayer(videoPreviewLayer!)
        session?.startRunning()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        session?.stopRunning()
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
        print("\(Date())")
    }
    
    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
    }
}

// MARK: capture configuration
extension TryMeViewController {
    
}
