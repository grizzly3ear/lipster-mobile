import UIKit
import ImagePicker
import SwiftSpinner

class LipColorDetectionController: UIViewController {
    
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var draggableSelectColorView: UIView!
    @IBOutlet weak var colorDetectPreview: UIView!
    @IBOutlet weak var findLipstickListButton: UIButton!
    
    var pickerController: ImagePickerController!
    var toggleCamera: Bool = false
    
    override func viewDidLoad() {
        navigationController?.isNavigationBarHidden = true
        
        setConfiguration()
        initDetectColorPreview()
        toggleCamera = true
        setUpGesture()
        
        self.present(pickerController, animated: true, completion: nil)
        print("view did load")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        if toggleCamera {
            setConfiguration()
            self.present(pickerController, animated: true, completion: nil)
        }
        print("view did appear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let viewControllers = self.navigationController?.viewControllers
        let count = viewControllers?.count
        if count! > 1 {
            if (viewControllers?[count! - 2] as? LipstickListViewController) != nil{
                toggleCamera = false
            }
        } else {
            toggleCamera = true
        }
        
        print("view did disappear")
    }
    
    @IBAction func onFindLipstickListTap(_ sender: UIButton) {
        performSegue(withIdentifier: "showLipstickList", sender: self)
    }
    
    @IBAction func onRetakeTap(_ sender: UIButton) {
        setConfiguration()
        self.present(pickerController, animated: true, completion: nil)
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
        colorDetectPreview.backgroundColor = color
        
        draggableSelectColorView.isHidden = false
        draggableSelectColorView.backgroundColor = color
        
        moveDetectColorPreview(at: sender.location(in: self.view))
        
        draggableSelectColorView.isHidden = true
    }
    
    @objc func onDrag(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            let touchPoint = sender.location(in: imagePreview)
            let color = imagePreview?.image?.getPixelColor(point: touchPoint, sourceView: imagePreview)
            colorDetectPreview.backgroundColor = color
            
            draggableSelectColorView.isHidden = false
            draggableSelectColorView.backgroundColor = color
            
            moveDetectColorPreview(at: sender.location(in: self.view))
        }
        if sender.state == .cancelled || sender.state == .ended {
            draggableSelectColorView.isHidden = true
        }
    }

}

// image picker delegate
extension LipColorDetectionController: ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        DispatchQueue.main.async {
            FaceDetection.getLipsLandmarks(for: self.imagePreview) { (color) in
                self.colorDetectPreview.backgroundColor = color
                print(color)
            }
        }
        
        pickerController.dismiss(animated: true, completion: nil)
        imagePreview.image = images.first
        toggleCamera = false
        self.colorDetectPreview.backgroundColor = .black
        SwiftSpinner.show("Processing Image...")
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
        draggableSelectColorView.layer.borderWidth = 5
        draggableSelectColorView.layer.borderColor = UIColor.white.cgColor
        draggableSelectColorView.isHidden = true
    }
    
    func moveDetectColorPreview(at point: CGPoint) {
        var displayPoint = point
        displayPoint.x = point.x + 45
        draggableSelectColorView.center = displayPoint
    }
}

// pass data to LipstickListViewController
extension LipColorDetectionController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLipstickList" {
            if let destination = segue.destination as? LipstickListViewController {
                destination.lipColor = colorDetectPreview.backgroundColor
            }
        }
    }
}
