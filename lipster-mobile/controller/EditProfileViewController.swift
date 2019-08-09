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

    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var userFirstname: UITextField!
    @IBOutlet weak var userLastname: UITextField!
    
    @IBOutlet weak var genderButton: PickerButton!
     let pickerValues: [String] = ["Female", "Male"]

    @IBAction func saveAction(_ sender: Any) {
         self.performSegue(withIdentifier: "showRecentlyView", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        genderButton.delegate = self
        genderButton.dataSource = self
        
            self.navigationItem.title = "Profile"
        UINavigationBar.appearance().tintColor = UIColor.white
      
        profileUserImageView.layer.cornerRadius = profileUserImageView.frame.size.width/2
        profileUserImageView.clipsToBounds = true
    
    
        var getUserEmail = "janatvara@gmail.com"
        var getUsername = "mmaimmaii"
        var getFirstname = "Natwara"
        var getLastname = "Jaratvithitpong"
    
    
        username.text = getUsername
        username.clearButtonMode = .whileEditing
        userFirstname.text = getFirstname
        userFirstname.clearButtonMode = .whileEditing
        userLastname.text = getLastname
        userLastname.clearButtonMode = .whileEditing
        userEmail.text = getUserEmail
        userEmail.clearButtonMode = .whileEditing
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

