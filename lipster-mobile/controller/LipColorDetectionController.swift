import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result

import Firebase

class LipColorDetectionController: UIViewController {
    
    // MARK: @IBOutlet
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var draggableSelectColorView: UIView!
    @IBOutlet weak var colorDetectPreview: UIView!
    @IBOutlet weak var findLipstickListButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    lazy var vision = Vision.vision()
    
    var imagePicker = UIImagePickerController()
    
    private lazy var annotationOverlayView: UIView = {
      precondition(isViewLoaded)
      let annotationOverlayView = UIView(frame: .zero)
      annotationOverlayView.translatesAutoresizingMaskIntoConstraints = false
      return annotationOverlayView
    }()
    
    let colorDetectionPipe = Signal<UIColor, NoError>.pipe()
    var colorDetectionObserver: Signal<UIColor, NoError>.Observer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinner.isHidden = true
        
        imageView.addSubview(annotationOverlayView)
        NSLayoutConstraint.activate([
          annotationOverlayView.topAnchor.constraint(equalTo: imageView.topAnchor),
          annotationOverlayView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
          annotationOverlayView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
          annotationOverlayView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
        ])

        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        initReactiveColorDetection()
        initDetectColorPreview()
        setUpGesture()
        
        popAlert()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showLipstickFromColorList" {
            if let destination = segue.destination as? LipstickListViewController {
                let hexColor: String = sender as! String
                destination.lipHexColor = hexColor
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
    }
    
    func popAlert() {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Video", style: .default, handler: { _ in
            self.openCamera()
        }))
        
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
        if UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary() {
        imagePicker.sourceType = .photoLibrary
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func onFindLipstickListTap(_ sender: UIButton) {
        let hexColor: String = colorDetectPreview.backgroundColor!.toHex!
        
        performSegue(withIdentifier: "showLipstickFromColorList", sender: hexColor)
    }
    
    @IBAction func onRetakeTap(_ sender: UIButton) {
        popAlert()
    }
}

extension LipColorDetectionController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        clearResults()
        if let pickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            updateImageView(with: pickedImage)
            
        }
        dismiss(animated: true) {
            self.detectFace(image: self.imageView.image!)
        }
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
    
    func initDetectColorPreview() {
        draggableSelectColorView.layer.borderWidth = 5
        draggableSelectColorView.layer.borderColor = UIColor.white.cgColor
        draggableSelectColorView.isHidden = true
    }
    
    func moveDetectColorPreview(at point: CGPoint) {
        var displayPoint = point
        displayPoint.y = point.y - 45
        draggableSelectColorView.center = displayPoint
    }

}

// MARK: Reactive init
extension LipColorDetectionController {
    func initReactiveColorDetection() {
        colorDetectionObserver = Signal<UIColor, NoError>.Observer(value: { (color) in
            self.spinner.isHidden = true
            self.colorDetectPreview.backgroundColor = color
        })
        colorDetectionPipe.output.observe(colorDetectionObserver!)
    }
}

extension LipColorDetectionController {
    func popCenterAlert(title: String, description: String, actionTitle: String, completion: (() -> Void)? = nil ) {
        let alert  = UIAlertController(title: title, message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: nil))
        self.present(alert, animated: true, completion: completion)
    }
}

// MARK: Detect func
extension LipColorDetectionController {
    func detectFace(image: UIImage?) {
        print("[detectFace] Starting detect face")
        
        self.spinner.isHidden = false
        guard let image = image else {
            // MARK: Implement image not found
            print("[detectFace] image not found")
            return
        }
        
        let options = VisionFaceDetectorOptions()
        options.contourMode = .all
        options.performanceMode = .accurate
        options.landmarkMode = .all
        
        let faceDetector = vision.faceDetector(options: options)
        
        let imageMetaData = VisionImageMetadata()
        imageMetaData.orientation = UIUtilityHelper.visionImageOrientation(from: image.imageOrientation)
        
        let visionImage = VisionImage(image: image)
        visionImage.metadata = imageMetaData
        
        faceDetector.process(visionImage) { (faces, error) in
            guard error == nil, let faces = faces, !faces.isEmpty else {
                // MARK: Implement face not found
                self.popCenterAlert(title: "Lip Color Detection", description: "Cannot detect a lip color in this image, plese try again.", actionTitle: "Ok")
                self.colorDetectionPipe.input.send(value: .black)
                print("[detectFace] Face Not Found")
                return
            }
            
            faces.forEach { face in
                print("[detectFace] Found Face")
                let transform = self.transformMatrix()
                let points = self.addContours(
                    forFace: face,
                    transform: transform,
                    debug: false
                )
                if let points = points {
                    print("[detectFace] found point")
                    var colors = [UIColor]()
                    for point in points {
                        colors.append(
                            self.imageView.getPixelColor(point: point)
                        )
                    }
                    print("[detectFace] colors: \(colors)")
                    // MARK: Average Color action
                    let avgColor = UIColor.averageColor(colors: colors, biasColor: .red, biasAmount: 7)
                    self.colorDetectionPipe.input.send(value: avgColor)
                    if colors.count == 0 {
                        self.popCenterAlert(title: "Lip Color Detection", description: "Your lip color is ambigous. Please try again with another image.", actionTitle: "Ok")
                    }
                    print(avgColor)
                }
                print("[detectFace] Last step")
            }
        }
        
    }
}

// MARK: Private func
extension LipColorDetectionController {
    private func updateImageView(with image: UIImage) {
        let orientation = UIApplication.shared.statusBarOrientation
        var scaledImageWidth: CGFloat = 0.0
        var scaledImageHeight: CGFloat = 0.0
        switch orientation {
        case .portrait, .portraitUpsideDown, .unknown:
            scaledImageWidth = imageView.bounds.size.width
            scaledImageHeight = image.size.height * scaledImageWidth / image.size.width
        case .landscapeLeft, .landscapeRight:
            scaledImageWidth = image.size.width * scaledImageHeight / image.size.height
            scaledImageHeight = imageView.bounds.size.height
        }
        DispatchQueue.global(qos: .userInitiated).async {
            // Scale image while maintaining aspect ratio so it displays better in the UIImageView.
            var scaledImage = image.scaledImage(
                with: CGSize(width: scaledImageWidth, height: scaledImageHeight)
            )
            scaledImage = scaledImage ?? image
            guard let finalImage = scaledImage else { return }
            DispatchQueue.main.async {
                self.imageView.image = finalImage
            }
        }
    }
    
    private func addContours(forFace face: VisionFace, transform: CGAffineTransform, key: String = "transformedPoint", debug: Bool = false) -> [CGPoint]? {
        
        var points = [CGPoint]()
        
        if let topUpperLipContour = face.contour(ofType: .upperLipTop) {
            for point in topUpperLipContour.points {
                let transformedPoint = pointFrom(point).applying(transform)
                if debug {
                    UIUtilityHelper.addCircle(
                        atPoint: transformedPoint,
                        to: annotationOverlayView,
                        color: UIColor.yellow,
                        radius: Constants.smallDotRadius
                    )
                    print("topUpperLipContour: transformedPoint: \(transformedPoint)")
                    print("topUpperLipContour: point: \(pointFrom(point))")
                }
                points.append(transformedPoint)
//                dictionaryPoints["transformedPoint"]?.append(transformedPoint)
//                dictionaryPoints["point"]?.append(pointFrom(point))
            }
        }
        if let bottomUpperLipContour = face.contour(ofType: .upperLipBottom) {
            for point in bottomUpperLipContour.points {
                let transformedPoint = pointFrom(point).applying(transform)
                if debug {
                    UIUtilityHelper.addCircle(
                        atPoint: transformedPoint,
                        to: annotationOverlayView,
                        color: UIColor.yellow,
                        radius: Constants.smallDotRadius
                    )
                    print("bottomUpperLipContour: transformedPoint: \(transformedPoint)")
                    print("bottomUpperLipContour: point: \(pointFrom(point))")
                }
                points.append(transformedPoint)
//                dictionaryPoints["transformedPoint"]?.append(transformedPoint)
//                dictionaryPoints["point"]?.append(pointFrom(point))
            }
        }
        if let topLowerLipContour = face.contour(ofType: .lowerLipTop) {
            for point in topLowerLipContour.points {
                let transformedPoint = pointFrom(point).applying(transform)
                if debug {
                    UIUtilityHelper.addCircle(
                        atPoint: transformedPoint,
                        to: annotationOverlayView,
                        color: UIColor.yellow,
                        radius: Constants.smallDotRadius
                    )
                    print("topLowerLipContour: transformedPoint: \(transformedPoint)")
                    print("topLowerLipContour: point: \(pointFrom(point))")
                }
                points.append(transformedPoint)
//                dictionaryPoints["transformedPoint"]?.append(transformedPoint)
//                dictionaryPoints["point"]?.append(pointFrom(point))
            }
        }
        if let bottomLowerLipContour = face.contour(ofType: .lowerLipBottom) {
            for point in bottomLowerLipContour.points {
                let transformedPoint = pointFrom(point).applying(transform)
                if debug {
                    UIUtilityHelper.addCircle(
                        atPoint: transformedPoint,
                        to: annotationOverlayView,
                        color: UIColor.yellow,
                        radius: Constants.smallDotRadius
                    )
                    print("bottomLowerLipContour: transformedPoint: \(transformedPoint)")
                    print("bottomLowerLipContour: point: \(pointFrom(point))")
                }
                points.append(transformedPoint)
//                dictionaryPoints["transformedPoint"]?.append(transformedPoint)
//                dictionaryPoints["point"]?.append(pointFrom(point))
            }
        }
        return points
    }
    
    private func addLandmarks(forFace face: VisionFace, transform: CGAffineTransform) {
      
        if let bottomMouthLandmark = face.landmark(ofType: .mouthBottom) {
            let point = pointFrom(bottomMouthLandmark.position)
            let transformedPoint = point.applying(transform)
            UIUtilityHelper.addCircle(
                atPoint: transformedPoint,
                to: annotationOverlayView,
                color: UIColor.red,
                radius: Constants.largeDotRadius
            )
            
        }
        if let leftMouthLandmark = face.landmark(ofType: .mouthLeft) {
            let point = pointFrom(leftMouthLandmark.position)
            let transformedPoint = point.applying(transform)
            UIUtilityHelper.addCircle(
                atPoint: transformedPoint,
                to: annotationOverlayView,
                color: UIColor.red,
                radius: Constants.largeDotRadius
            )
        }
        if let rightMouthLandmark = face.landmark(ofType: .mouthRight) {
            let point = pointFrom(rightMouthLandmark.position)
            let transformedPoint = point.applying(transform)
            UIUtilityHelper.addCircle(
                atPoint: transformedPoint,
                to: annotationOverlayView,
                color: UIColor.red,
                radius: Constants.largeDotRadius
            )
        }
    }
    
    private func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (key.rawValue, value) })
    }
    
    private func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
    
    private func clearResults() {
        removeDetectionAnnotations()
        colorDetectPreview.backgroundColor = .black
    }
    
    private func pointFrom(_ visionPoint: VisionPoint) -> CGPoint {
        return CGPoint(x: CGFloat(visionPoint.x.floatValue), y: CGFloat(visionPoint.y.floatValue))
    }
    
    private func transformMatrix() -> CGAffineTransform {
        guard let image = imageView.image else { return CGAffineTransform() }
        let imageViewWidth = imageView.frame.size.width
        let imageViewHeight = imageView.frame.size.height
        let imageWidth = image.size.width
        let imageHeight = image.size.height

        let imageViewAspectRatio = imageViewWidth / imageViewHeight
        let imageAspectRatio = imageWidth / imageHeight
        let scale = (imageViewAspectRatio > imageAspectRatio)
        ? imageViewHeight / imageHeight : imageViewWidth / imageWidth

        let scaledImageWidth = imageWidth * scale
        let scaledImageHeight = imageHeight * scale
        let xValue = (imageViewWidth - scaledImageWidth) / CGFloat(2.0)
        let yValue = (imageViewHeight - scaledImageHeight) / CGFloat(2.0)

        var transform = CGAffineTransform.identity.translatedBy(x: xValue, y: yValue)
        transform = transform.scaledBy(x: scale, y: scale)
        return transform
    }
    
    private func removeDetectionAnnotations() {
        for annotationView in annotationOverlayView.subviews {
            annotationView.removeFromSuperview()
        }
    }
}

private enum Constants {
    static let smallDotRadius: CGFloat = 5.0
    static let largeDotRadius: CGFloat = 10.0
    static let lineColor = UIColor.yellow.cgColor
    static let fillColor = UIColor.clear.cgColor
}
