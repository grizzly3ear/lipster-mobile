//
//  ProfileViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 11/5/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit
import PickerButton

class EditProfileViewController: UIViewController {

    @IBOutlet weak var profileUserImageView: UIImageView!

    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var firstnameLabel: UITextField!
    @IBOutlet weak var lastnameLabel: UITextField!
    @IBOutlet weak var imagePickerBackground: UIView!
    @IBOutlet weak var genderPicker: PickerButton!
    
    var imagePicker = UIImagePickerController()
    var gender: String?
    let pickerValues: [String] = ["Female", "Male"]

    @IBAction func goBack(_ sender: Any) {
        hero.dismissViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        genderPicker.delegate = self
        genderPicker.dataSource = self
      
        profileUserImageView.sd_setImage(with: URL(string: User.shared.imageURL!), placeholderImage: UIImage(named: "profile-user"))
        profileUserImageView.layer.cornerRadius = profileUserImageView.frame.size.width / 2
        profileUserImageView.clipsToBounds = true
        
        imagePickerBackground.layer.cornerRadius = imagePickerBackground.frame.size.width / 2
        imagePickerBackground.clipsToBounds = true

        firstnameLabel.text = User.shared.firstname!
        firstnameLabel.clearButtonMode = .whileEditing
        
        lastnameLabel.text = User.shared.lastname!
        lastnameLabel.clearButtonMode = .whileEditing
        
        emailLabel.text = User.shared.email!
        emailLabel.clearButtonMode = .whileEditing
    
        emailLabel.isUserInteractionEnabled = false
        firstnameLabel.delegate = self
        lastnameLabel.delegate = self
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        gender = User.shared.gender!
        if User.shared.gender?.lowercased() == "female" {
            genderPicker.selectRow(0, inComponent: 0, animated: false)
        } else {
            genderPicker.selectRow(1, inComponent: 0, animated: false)
        }
    }

    @IBAction func submit(_ sender: Any) {
        UserRepository.editProfile(firstname: firstnameLabel.text!, lastname: lastnameLabel.text!, gender: gender!, image: profileUserImageView.image!) { (userModel) in
            if let user = userModel {
                User.setSingletonUser(user: user)
            }
            self.hero.dismissViewController()
        }
    }
    
    @IBAction func editImageClick(_ sender: Any) {
        self.popAlert()
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            
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
}

extension EditProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerValues[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        gender = pickerValues[row]
    }
    
}

extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        profileUserImageView.image = image
        self.dismiss(animated: true, completion: nil)
    }
}



