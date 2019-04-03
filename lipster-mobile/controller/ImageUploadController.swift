import UIKit
import ImagePicker

class ImageUploadController: UIViewController {
    
    @IBOutlet weak var imagePreview: UIImageView!
    let pickerController = ImagePickerController()
    var toggleCamera: Bool = false
    
    override func viewDidLoad() {
        pickerController.delegate = self
        pickerController.imageLimit = 1
        
        toggleCamera = true
        self.present(pickerController, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if toggleCamera {
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        toggleCamera = true
    }
    
}

extension ImageUploadController: ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePreview.image = images.first
        toggleCamera = false
        pickerController.dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        toggleCamera = false
        pickerController.dismiss(animated: true, completion: nil)
    }
    
    
}
