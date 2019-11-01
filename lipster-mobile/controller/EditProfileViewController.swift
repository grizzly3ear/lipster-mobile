//
//  ProfileViewController.swift
//  lipster-mobile
//
//  Created by Mainatvara on 11/5/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit
import  PickerButton

class EditProfileViewController: UIViewController {

    @IBOutlet weak var profileUserImageView: UIImageView!

    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var firstnameLabel: UITextField!
    @IBOutlet weak var lastnameLabel: UITextField!
    
    @IBOutlet weak var genderPicker: PickerButton!
     let pickerValues: [String] = ["Female", "Male"]

    @IBAction func saveAction(_ sender: Any) {
         
    }
    @IBAction func goBack(_ sender: Any) {
        hero.dismissViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        genderPicker.delegate = self
        genderPicker.dataSource = self
        
            self.navigationItem.title = "Profile"
        UINavigationBar.appearance().tintColor = UIColor.white
      
        profileUserImageView.layer.cornerRadius = profileUserImageView.frame.size.width/2
        profileUserImageView.clipsToBounds = true
    
    
        let email = "janatvara@gmail.com"
        let username = "mmaimmaii"
        let firstname = "Natwara"
        let lastname = "Jaratvithitpong"
    
        usernameLabel.text = username
        usernameLabel.clearButtonMode = .whileEditing
        
        firstnameLabel.text = firstname
        firstnameLabel.clearButtonMode = .whileEditing
        
        lastnameLabel.text = lastname
        lastnameLabel.clearButtonMode = .whileEditing
        
        emailLabel.text = email
        emailLabel.clearButtonMode = .whileEditing
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
}

