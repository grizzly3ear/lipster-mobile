import UIKit
import ImagePicker

class ImageUploadController: UIViewController {
    
    @IBOutlet weak var imagePreview: UIImageView!
    let pickerController = ImagePickerController()
    
    override func viewDidLoad() {
        pickerController.delegate = self
        pickerController.imageLimit = 1
        self.present(pickerController, animated: true, completion: nil)
    }
//
//    func takePicture() {
//        pickerController.sourceType = .camera
//        self.present(pickerController, animated: true, completion: nil)
//    }
//
//    func selectImageFromPhotoLibrary() {
//        pickerController.sourceType = .photoLibrary
//        self.present(pickerController, animated: true, completion: nil)
//    }
//
    
}

extension ImageUploadController: ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePreview.image = images.first
        pickerController.dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        pickerController.dismiss(animated: true, completion: nil)
    }
    
    
}
