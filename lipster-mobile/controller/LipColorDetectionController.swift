import UIKit
import ImagePicker
import SwiftSpinner

class LipColorDetectionController: UIViewController {
    
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var detectColorPreview: UIView!
    
    var pickerController: ImagePickerController!
    var toggleCamera: Bool = false
    
    override func viewDidLoad() {
        setConfiguration()
        initDetectColorPreview()
        toggleCamera = true
        setUpGesture()
        
        self.present(pickerController, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if toggleCamera {
            setConfiguration()
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        toggleCamera = true
    }
    
}

// set up gesture on imagePreview
extension LipColorDetectionController {
    func setUpGesture() {
        imagePreview.isUserInteractionEnabled = true
        setUpTapGesture()
        setupDragGesture()
    }
    
    func setUpTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onTap))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        imagePreview.addGestureRecognizer(tapGesture)
    }
    
    func setupDragGesture() {
        let dragGesture = UIPanGestureRecognizer(target: self, action: #selector(self.onDrag))
        dragGesture.minimumNumberOfTouches = 1
        imagePreview.addGestureRecognizer(dragGesture)
    }
    
    @objc func onTap(_ sender: UITapGestureRecognizer) {
        let touchPoint = sender.location(in: imagePreview)
        let color = imagePreview?.image?.getPixelColor(point: touchPoint, sourceView: imagePreview)
        detectColorPreview.backgroundColor = color
        moveDetectColorPreview(at: touchPoint)
    }
    
    @objc func onDrag(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: imagePreview)
        let color = imagePreview?.image?.getPixelColor(point: touchPoint, sourceView: imagePreview)
        print("touch point: \(touchPoint)")
        detectColorPreview.backgroundColor = color
        
        moveDetectColorPreview(at: sender.location(in: self.view))
        
    }

}

// image picker delegate
extension LipColorDetectionController: ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        SwiftSpinner.show("Processing Image...")
        imagePreview.image = images.first
        toggleCamera = false
        print("image set")
        pickerController.dismiss(animated: true, completion: nil)
        print("after dismiss")
        

        FaceDetection.getLipsLandmarks(for: imagePreview) { (color) in
            DispatchQueue.main.async {
//                self.detectColorPreview.backgroundColor = color
                print(color)
            }
        }
        SwiftSpinner.hide()
        
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        toggleCamera = false
        pickerController.dismiss(animated: true, completion: nil)
    }
}

// image picker config
extension LipColorDetectionController {
    func setConfiguration() {
        let config = Configuration()
        config.allowMultiplePhotoSelection = true
        
        pickerController = ImagePickerController(configuration: config)
        pickerController.delegate = self
        pickerController.imageLimit = 1
    }
}

// detectColorPreview dragable
extension LipColorDetectionController {
    func initDetectColorPreview() {
        detectColorPreview.layer.borderWidth = 5
        detectColorPreview.layer.borderColor = UIColor.white.cgColor
    }
    
    func moveDetectColorPreview(at point: CGPoint) {
        var displayPoint = point
        displayPoint.x = point.x + 45
        detectColorPreview.center = displayPoint
    }
}
