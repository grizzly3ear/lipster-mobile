import UIKit
import ImagePicker
import SwiftSpinner
import ReactiveSwift
import ReactiveCocoa
import Result

class LipColorDetectionController: UIViewController {
    
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var draggableSelectColorView: UIView!
    @IBOutlet weak var colorDetectPreview: UIView!
    @IBOutlet weak var findLipstickListButton: UIButton!
    
    var pickerController: ImagePickerController!
    var toggleCamera: Bool = false
    let faceDetection = FaceDetection()
    let request = HttpRequest("http://18.136.104.217", nil)
    
    let colorDetectionPipe = Signal<UIColor, NoError>.pipe()
    var colorDetectionObserver: Signal<UIColor, NoError>.Observer?
    
    override func viewDidLoad() {
        navigationController?.isNavigationBarHidden = true
        
        setConfiguration()
        initDetectColorPreview()
        toggleCamera = true
        setUpGesture()
        
        configureReactiveColorDetection()
        
        self.present(pickerController, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        if toggleCamera {
            setConfiguration()
            self.present(pickerController, animated: true, completion: nil)
        }
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
    }
    
    @IBAction func onFindLipstickListTap(_ sender: UIButton) {
        let hexColor: String = colorDetectPreview.backgroundColor!.toHex!
        
        performSegue(withIdentifier: "showLipstickFromColorList", sender: hexColor)
    }
    
    @IBAction func onRetakeTap(_ sender: UIButton) {
        setConfiguration()
        self.present(pickerController, animated: true, completion: nil)
    }
    
}

// MARK: Set up gesture on imagePreview
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
        let color = imagePreview?.getPixelColor(point: touchPoint)
        colorDetectPreview.backgroundColor = color
        
        draggableSelectColorView.isHidden = false
        draggableSelectColorView.backgroundColor = color
        
        moveDetectColorPreview(at: sender.location(in: self.view))
        
        draggableSelectColorView.isHidden = true
    }
    
    @objc func onDrag(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            let touchPoint = sender.location(in: imagePreview)
            let color = imagePreview?.getPixelColor(point: touchPoint)
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

// MARK: Reactive init
extension LipColorDetectionController {
    func configureReactiveColorDetection() {
        colorDetectionObserver = Signal<UIColor, NoError>.Observer(value: { (color) in
            self.colorDetectPreview.backgroundColor = color
        })
        
        colorDetectionPipe.output.observe(colorDetectionObserver!)
    }
}

// MARK: Image picker delegate
extension LipColorDetectionController: ImagePickerDelegate {
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        SwiftSpinner.show("Processing Image...")
        imagePreview.image = images.first
        pickerController.dismiss(animated: true, completion: nil)
        
        toggleCamera = false
        self.colorDetectPreview.backgroundColor = .black
        
        DispatchQueue.main.async {
            self.faceDetection.getLipColorFromImage(for: self.imagePreview, complete: { (color) in
                self.colorDetectionPipe.input.send(value: color!)
            })
            SwiftSpinner.hide()
        }
    
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
        if segue.identifier == "showLipstickFromColorList" {
            if let destination = segue.destination as? LipstickListViewController {
                var lipstickData = [Lipstick]()
                let hexColor: String = sender as! String
                
                self.request.get("api/lipstick/color/\(hexColor)", nil, nil) { (response) -> (Void) in
                    lipstickData = Lipstick.makeArrayFromLipstickColorResource(response: response)
                    destination.lipstickList = lipstickData
                    destination.lipListTableView.reloadData()
                    destination.lipListTableView.layoutIfNeeded()
                    destination.lipListTableView.setNeedsLayout()
                }
                
                
            }
        }
    }
}
