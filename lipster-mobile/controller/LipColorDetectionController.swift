import UIKit
import SwiftSpinner
import ReactiveSwift
import ReactiveCocoa
import Result

import Firebase

class LipColorDetectionController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var draggableSelectColorView: UIView!
    @IBOutlet weak var colorDetectPreview: UIView!
    @IBOutlet weak var findLipstickListButton: UIButton!
    
    var imagePicker = UIImagePickerController()
    let request = HttpRequest()
    lazy var vision = Vision.vision()
    
    let colorDetectionPipe = Signal<UIColor, NoError>.pipe()
    var colorDetectionObserver: Signal<UIColor, NoError>.Observer?
    
    override func viewDidLoad() {
        navigationController?.isNavigationBarHidden = true
        
        imageView.addSubview(annotationOverlayView)
        initDetectColorPreview()
        setUpGesture()
        initReactiveColorDetection()
        imagePicker.delegate = self
        popAlert()
    }
    
    func popAlert() {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary() {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    private lazy var annotationOverlayView: UIView = {
        precondition(isViewLoaded)
        let annotationOverlayView = UIView(frame: .zero)
        annotationOverlayView.translatesAutoresizingMaskIntoConstraints = false
        return annotationOverlayView
    }()
    
    @IBAction func onFindLipstickListTap(_ sender: UIButton) {
        let hexColor: String = colorDetectPreview.backgroundColor!.toHex!
        
        performSegue(withIdentifier: "showLipstickFromColorList", sender: hexColor)
    }
    
    @IBAction func onRetakeTap(_ sender: UIButton) {
        popAlert()
    }
    private func clearResults() {
        removeDetectionAnnotations()
    }
    private func removeDetectionAnnotations() {
        for annotationView in annotationOverlayView.subviews {
            annotationView.removeFromSuperview()
        }
    }
    
}

extension LipColorDetectionController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
        ) {
    
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        clearResults()
        if let pickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            imageView.image = pickedImage
            imageView.contentMode = .scaleAspectFit
//            updateImageView(with: pickedImage)
            detectFaces(image: pickedImage)
        }
        dismiss(animated: true)
    }
}
// MARK: Set up gesture on imagePreview
extension LipColorDetectionController {
    func setUpGesture() {
        imageView.isUserInteractionEnabled = true
        setUpTapGesture()
        setupDragGesture()
    }
    
    func setUpTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.onTap))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        imageView.addGestureRecognizer(tapGesture)
    }
    
    func setupDragGesture() {
        let dragGesture = UIPanGestureRecognizer(target: self, action: #selector(self.onDrag))
        dragGesture.minimumNumberOfTouches = 1
        imageView.addGestureRecognizer(dragGesture)
    }
    
    @objc func onTap(_ sender: UITapGestureRecognizer) {
        let touchPoint = sender.location(in: imageView)
        let color = imageView?.getPixelColor(point: touchPoint)
        colorDetectPreview.backgroundColor = color
        
        draggableSelectColorView.isHidden = false
        draggableSelectColorView.backgroundColor = color
        
        moveDetectColorPreview(at: sender.location(in: self.view))
        
        draggableSelectColorView.isHidden = true
    }
    
    @objc func onDrag(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            let touchPoint = sender.location(in: imageView)
            let color = imageView?.getPixelColor(point: touchPoint)
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
    func initReactiveColorDetection() {
        colorDetectionObserver = Signal<UIColor, NoError>.Observer(value: { (color) in
            self.colorDetectPreview.backgroundColor = color
        })
        
        colorDetectionPipe.output.observe(colorDetectionObserver!)
    }
}

//
//// MARK: Image picker delegate
//extension LipColorDetectionController: ImagePickerDelegate {
//
//    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
//    }
//
//    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
//
////        SwiftSpinner.show("Processing Image...")
//        imageView.image = images.first
//        pickerController.dismiss(animated: true, completion: nil)
//
//        toggleCamera = false
//        self.colorDetectPreview.backgroundColor = .black
//
////        DispatchQueue.main.async {
////            self.faceDetection.getLipColorFromImage(for: self.imagePreview, complete: { (color) in
////                self.colorDetectionPipe.input.send(value: color!)
////            })
////            SwiftSpinner.hide()
////        }
//
//        detectFaces(image: imageView.image)
//    }
//
//    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
//        toggleCamera = false
//        pickerController.dismiss(animated: true, completion: nil)
//    }
//}

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
                
//                self.request.get("api/lipstick/color/\(hexColor)", nil, nil) { (response) -> (Void) in
//                    lipstickData = Lipstick.makeArrayFromLipstickColorResource(response: response)
//                    destination.lipstickList = lipstickData
//                    destination.lipListTableView.reloadData()
//                    destination.lipListTableView.layoutIfNeeded()
//                    destination.lipListTableView.setNeedsLayout()
//                }
                
                
            }
        }
    }
}

extension LipColorDetectionController {
    
    
    func detectFaces(image: UIImage?) {
        guard let image = image else { return }
        
        // Create a face detector with options.
        // [START config_face]
        let options = VisionFaceDetectorOptions()
        options.landmarkMode = .all
        options.classificationMode = .all
        options.performanceMode = .accurate
        options.contourMode = .all
        // [END config_face]
        
        // [START init_face]
        let faceDetector = vision.faceDetector(options: options)
        // [END init_face]
        
        // Define the metadata for the image.
        let imageMetadata = VisionImageMetadata()
        imageMetadata.orientation = UIUtilityHelper.visionImageOrientation(from: image.imageOrientation)
        
        // Initialize a VisionImage object with the given UIImage.
        let visionImage = VisionImage(image: image)
        visionImage.metadata = imageMetadata
        
        // [START detect_faces]
        faceDetector.process(visionImage) { faces, error in
            guard error == nil, let faces = faces, !faces.isEmpty else {
                // Faces not detected
                print("Not Detect")
                return
            }
            
            // Faces detected
            // [START_EXCLUDE]
            faces.forEach { face in
                let transform = self.transformMatrix()
//                self.addLandmarks(forFace: face, transform: transform)
                self.addContours(forFace: face, transform: transform)
            }
            // [END_EXCLUDE]
        }
        // [END detect_faces]
    }
    
    private func transformMatrix() -> CGAffineTransform {
        guard let image = imageView.image else { return CGAffineTransform() }
        let imageViewWidth = imageView.frame.size.width
        let imageViewHeight = imageView.frame.size.height
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        
        let imageViewAspectRatio = imageViewWidth / imageViewHeight
        let imageAspectRatio = imageWidth / imageHeight
        let scale = (imageViewAspectRatio > imageAspectRatio) ?
            imageViewHeight / imageHeight :
            imageViewWidth / imageWidth

        let scaledImageWidth = imageWidth * scale
        let scaledImageHeight = imageHeight * scale
        let xValue = (imageViewWidth - scaledImageWidth) / CGFloat(2.0)
        let yValue = (imageViewHeight - scaledImageHeight) / CGFloat(2.0)
        
        var transform = CGAffineTransform.identity.translatedBy(x: xValue, y: yValue)
        transform = transform.scaledBy(x: scale, y: scale)
        return transform
    }
    
    private func addContours(forFace face: VisionFace, transform: CGAffineTransform) {
        // Lips
        print("found!!!")
        if let topUpperLipContour = face.contour(ofType: .upperLipTop) {
            for point in topUpperLipContour.points {
                let transformedPoint = pointFrom(point).applying(transform);
                UIUtilityHelper.addCircle(
                    atPoint: transformedPoint,
                    to: annotationOverlayView,
                    color: UIColor.yellow,
                    radius: Constants.smallDotRadius
                )
            }
        }
        if let bottomUpperLipContour = face.contour(ofType: .upperLipBottom) {
            for point in bottomUpperLipContour.points {
                let transformedPoint = pointFrom(point).applying(transform);
                UIUtilityHelper.addCircle(
                    atPoint: transformedPoint,
                    to: annotationOverlayView,
                    color: UIColor.yellow,
                    radius: Constants.smallDotRadius
                )
            }
        }
        if let topLowerLipContour = face.contour(ofType: .lowerLipTop) {
            for point in topLowerLipContour.points {
                let transformedPoint = pointFrom(point).applying(transform);
                UIUtilityHelper.addCircle(
                    atPoint: transformedPoint,
                    to: annotationOverlayView,
                    color: UIColor.yellow,
                    radius: Constants.smallDotRadius
                )
            }
        }
        if let bottomLowerLipContour = face.contour(ofType: .lowerLipBottom) {
            for point in bottomLowerLipContour.points {
                let transformedPoint = pointFrom(point).applying(transform);
                UIUtilityHelper.addCircle(
                    atPoint: transformedPoint,
                    to: annotationOverlayView,
                    color: UIColor.yellow,
                    radius: Constants.smallDotRadius
                )
            }
        }
        
    }
    
    private func pointFrom(_ visionPoint: VisionPoint) -> CGPoint {
        return CGPoint(x: CGFloat(visionPoint.x.floatValue), y: CGFloat(visionPoint.y.floatValue))
    }
//    private func updateImageView(with image: UIImage) {
//        let orientation = UIApplication.shared.statusBarOrientation
//        var scaledImageWidth: CGFloat = 0.0
//        var scaledImageHeight: CGFloat = 0.0
//        switch orientation {
//        case .portrait, .portraitUpsideDown, .unknown:
//            scaledImageWidth = imageView.bounds.size.width
//            scaledImageHeight = image.size.height * scaledImageWidth / image.size.width
//        case .landscapeLeft, .landscapeRight:
//            scaledImageWidth = image.size.width * scaledImageHeight / image.size.height
//            scaledImageHeight = imageView.bounds.size.height
//        }
//        DispatchQueue.global(qos: .userInitiated).async {
//            // Scale image while maintaining aspect ratio so it displays better in the UIImageView.
//            var scaledImage = image.scaledImage(
//                with: CGSize(width: scaledImageWidth, height: scaledImageHeight)
//            )
//            scaledImage = scaledImage ?? image
//            guard let finalImage = scaledImage else { return }
//            DispatchQueue.main.async {
//                self.imageView.image = finalImage
//            }
//        }
//    }
}

private enum Constants {
    static let smallDotRadius: CGFloat = 5.0
    static let largeDotRadius: CGFloat = 10.0
}

fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
